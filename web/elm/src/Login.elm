module Login exposing (Model, Msg(..), init, update, view, subscriptions)

import Erl
import Html exposing (Html)
import Html.Attributes as Attributes exposing (id, class)
import Html.Events exposing (onInput, onSubmit)
import Http
import Navigation
import Task

import Concourse
import Concourse.AuthMethod
import Concourse.Login
import StrictEvents exposing (onLeftClick)

type alias Ports =
  { title : String -> Cmd Msg
  }

type alias BasicAuthFields =
    { username : String
    , password : String
    }

type alias Model =
  { teamName : String
  , authMethods : Maybe (List Concourse.AuthMethod)
  , hasTeamSelectionInBrowserHistory : Bool
  , redirect : Maybe String
  , basicAuthInput : Maybe BasicAuthFields
  }

type Msg
  = Noop
  | AuthFetched (Result Http.Error (List Concourse.AuthMethod))
  | NoAuthSubmit
  | BasicAuthUsernameChanged String
  | BasicAuthPasswordChanged String
  | BasicAuthSubmit
  | LoginTokenReceived (Result Http.Error Concourse.AuthToken)
  | GoBack

init : Ports -> String -> Maybe String -> (Model, Cmd Msg)
init ports teamName redirect =
  ( { teamName = teamName
    , authMethods = Nothing
    , hasTeamSelectionInBrowserHistory = False
    , redirect = redirect
    , basicAuthInput = Nothing
    }
  , Cmd.batch
      [ Cmd.map
          AuthFetched <|
            Task.perform Err Ok <|
              Concourse.AuthMethod.fetchAll teamName
      , ports.title "Login - "
      ]
  )

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Noop ->
      (model, Cmd.none)
    AuthFetched (Ok authMethods) ->
      let
        newInputFields =
          if List.member Concourse.AuthMethodBasic authMethods then
            Just <|
              { username = ""
              , password = ""
              }
          else
            Nothing
      in
        ( { model
          | authMethods = Just authMethods
          , basicAuthInput = newInputFields
          }
        , Cmd.none
        )
    AuthFetched (Err err) ->
      Debug.log ("failed to fetch auth methods: " ++ toString err) <|
        (model, Cmd.none)
    NoAuthSubmit ->
      (model, noAuthSubmit model.teamName)
    LoginTokenReceived (Ok _) ->
        ( model
        , Navigation.newUrl (redirectUrl model.redirect)
        )
    LoginTokenReceived (Err err) ->
      Debug.log ("login failed: " ++ toString err) <|
        (model, Cmd.none)
    BasicAuthUsernameChanged un ->
      ( case model.basicAuthInput of
          Nothing ->
            Debug.log "input to nonexistent UN field: "
              model
          Just fields ->
            { model
            | basicAuthInput =
                Just
                  { fields
                  | username = un
                  }
            }
      , Cmd.none)
    BasicAuthPasswordChanged pw ->
      ( case model.basicAuthInput of
          Nothing ->
            Debug.log "input to nonexistent PW field: "
              model
          Just fields ->
            { model
            | basicAuthInput =
                Just
                  { fields
                  | password = pw
                  }
            }
      , Cmd.none)
    BasicAuthSubmit ->
      ( model
      , case model.basicAuthInput of
          Nothing ->
            Debug.log "tried to submit illegal basic auth"
              Cmd.none
          Just fields ->
            basicAuthSubmit model.teamName fields
      )
    GoBack ->
      case model.hasTeamSelectionInBrowserHistory of -- TODO this goes away?
        True ->
          (model, Navigation.back 1)
        False ->
          (model, Navigation.newUrl <| teamSelectionRoute model.redirect)

redirectUrl : Maybe String -> String
redirectUrl redirectParam =
  case redirectParam of
    Nothing ->
      "/"
    Just redirectUrl ->
      redirectUrl

teamSelectionRoute : Maybe String -> String
teamSelectionRoute redirectParam =
  case redirectParam of
    Nothing ->
      "/login"
    Just r ->
      Erl.parse "/login"
      |> Erl.addQuery "redirect" r
      |> Erl.toString

routeWithRedirect : Maybe String -> String -> String
routeWithRedirect redirectParam route =
  let
    actualRedirect =
      case redirectParam of
        Nothing -> indexPageUrl
        Just r -> r
  in
    Erl.parse route
    |> Erl.addQuery "redirect" actualRedirect
    |> Erl.toString

indexPageUrl : String
indexPageUrl = "/"

view : Model -> Html Msg
view model =
  Html.div [ class "login-page" ]
    [ Html.div
        [ class "small-title" ]
        [ Html.a
            [ onLeftClick GoBack
            , Attributes.href <| teamSelectionRoute model.redirect
            ]
            [ Html.i [class "fa fa-fw fa-chevron-left"] []
            , Html.text "back to team selection"
            ]
        ]
    , Html.div
        [ class "login-box auth-methods" ] <|
        [ Html.div
            [ class "auth-methods-title" ]
            [ Html.text "logging in to "
            , Html.span
                [ class "bright-text" ]
                [ Html.text model.teamName ]
            ]
        ] ++
          case model.authMethods of
            Nothing -> [ viewLoading ]
            Just methods ->
              case (viewBasicAuthForm methods, viewOAuthButtons model.redirect methods) of
                (Just basicForm, Just buttons) ->
                  [ buttons, viewOrBar, basicForm ]
                (Just basicForm, Nothing) -> [ basicForm ]
                (Nothing, Just buttons) -> [ buttons ]
                (Nothing, Nothing) -> [ viewNoAuthButton ]
    ]

viewLoading : Html Msg
viewLoading =
  Html.div [class "loading"]
    [ Html.i [class "fa fa-fw fa-spin fa-circle-o-notch"] []
    ]

viewOrBar : Html Msg
viewOrBar =
  Html.div
    [ class "or-bar" ]
    [ Html.div [] []
    , Html.span [] [ Html.text "or" ]
    ]

viewNoAuthButton : Html Msg
viewNoAuthButton =
  Html.form
    [ class "auth-method login-button"
    ]
    [ Html.button
        [ onLeftClick NoAuthSubmit ]
        [ Html.text "login" ]
    ]

viewBasicAuthForm : List Concourse.AuthMethod -> Maybe (Html Msg)
viewBasicAuthForm methods =
  if List.member Concourse.AuthMethodBasic methods then
    Just <|
      Html.form
        [ class "auth-method basic-auth"
        ]
        [ Html.label
            [ Attributes.for "basic-auth-username-input" ]
            [ Html.text "username" ]
        , Html.div
            [ class "input-holder" ]
            [ Html.input
                [ id "basic-auth-username-input"
                , Attributes.type' "text"
                , Attributes.name "username"
                , onInput BasicAuthUsernameChanged
                , onSubmit BasicAuthSubmit
                ]
                []
            ]
        , Html.label
            [ Attributes.for "basic-auth-password-input" ]
            [ Html.text "password" ]
        , Html.div [class "input-holder"] -- for LastPass web UI
            [ Html.input
                [ id "basic-auth-password-input"
                , Attributes.type' "password"
                , Attributes.name "password"
                , onInput BasicAuthPasswordChanged
                , onSubmit BasicAuthSubmit
                ]
                []
            ]
        , Html.div
            [ class "login-button" ]
            [ Html.button
                [ onLeftClick BasicAuthSubmit ]
                [ Html.text "login" ]
            ]
        ]
  else
    Nothing

viewOAuthButtons : Maybe String -> List Concourse.AuthMethod -> Maybe (Html Msg)
viewOAuthButtons redirectParam methods =
  case List.filterMap (viewOAuthButton redirectParam) methods of
    [] ->
      Nothing

    buttons ->
      Just <|
        Html.div [class "oauth-buttons"] buttons

viewOAuthButton : Maybe String -> Concourse.AuthMethod -> Maybe (Html Msg)
viewOAuthButton redirect method =
  case method of
    Concourse.AuthMethodBasic ->
      Nothing
    Concourse.AuthMethodOAuth oAuthMethod ->
      Just <|
        Html.div [class "auth-method login-button"] [
          Html.a
            [ Attributes.href <| routeWithRedirect redirect oAuthMethod.authUrl ]
            [ Html.text <| "login with " ++ oAuthMethod.displayName ]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

noAuthSubmit : String -> Cmd Msg
noAuthSubmit teamName =
  Cmd.map LoginTokenReceived << Task.perform Err Ok <|
    Concourse.Login.noAuth teamName


basicAuthSubmit : String -> BasicAuthFields -> Cmd Msg
basicAuthSubmit teamName fields =
  Cmd.map LoginTokenReceived << Task.perform Err Ok <|
    Concourse.Login.basicAuth teamName fields.username fields.password
