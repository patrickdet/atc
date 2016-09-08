// This file was generated by counterfeiter
package buildstarterfakes

import (
	"sync"

	"code.cloudfoundry.org/lager"
	"github.com/concourse/atc"
	"github.com/concourse/atc/scheduler/buildstarter"
)

type FakeBuildStarter struct {
	TryStartPendingBuildsForJobStub        func(logger lager.Logger, jobConfig atc.JobConfig, resourceConfigs atc.ResourceConfigs, resourceTypes atc.ResourceTypes) error
	tryStartPendingBuildsForJobMutex       sync.RWMutex
	tryStartPendingBuildsForJobArgsForCall []struct {
		logger          lager.Logger
		jobConfig       atc.JobConfig
		resourceConfigs atc.ResourceConfigs
		resourceTypes   atc.ResourceTypes
	}
	tryStartPendingBuildsForJobReturns struct {
		result1 error
	}
	TryStartAllPendingBuildsStub        func(logger lager.Logger, jobConfigs atc.JobConfigs, resourceConfigs atc.ResourceConfigs, resourceTypes atc.ResourceTypes) error
	tryStartAllPendingBuildsMutex       sync.RWMutex
	tryStartAllPendingBuildsArgsForCall []struct {
		logger          lager.Logger
		jobConfigs      atc.JobConfigs
		resourceConfigs atc.ResourceConfigs
		resourceTypes   atc.ResourceTypes
	}
	tryStartAllPendingBuildsReturns struct {
		result1 error
	}
	invocations      map[string][][]interface{}
	invocationsMutex sync.RWMutex
}

func (fake *FakeBuildStarter) TryStartPendingBuildsForJob(logger lager.Logger, jobConfig atc.JobConfig, resourceConfigs atc.ResourceConfigs, resourceTypes atc.ResourceTypes) error {
	fake.tryStartPendingBuildsForJobMutex.Lock()
	fake.tryStartPendingBuildsForJobArgsForCall = append(fake.tryStartPendingBuildsForJobArgsForCall, struct {
		logger          lager.Logger
		jobConfig       atc.JobConfig
		resourceConfigs atc.ResourceConfigs
		resourceTypes   atc.ResourceTypes
	}{logger, jobConfig, resourceConfigs, resourceTypes})
	fake.recordInvocation("TryStartPendingBuildsForJob", []interface{}{logger, jobConfig, resourceConfigs, resourceTypes})
	fake.tryStartPendingBuildsForJobMutex.Unlock()
	if fake.TryStartPendingBuildsForJobStub != nil {
		return fake.TryStartPendingBuildsForJobStub(logger, jobConfig, resourceConfigs, resourceTypes)
	} else {
		return fake.tryStartPendingBuildsForJobReturns.result1
	}
}

func (fake *FakeBuildStarter) TryStartPendingBuildsForJobCallCount() int {
	fake.tryStartPendingBuildsForJobMutex.RLock()
	defer fake.tryStartPendingBuildsForJobMutex.RUnlock()
	return len(fake.tryStartPendingBuildsForJobArgsForCall)
}

func (fake *FakeBuildStarter) TryStartPendingBuildsForJobArgsForCall(i int) (lager.Logger, atc.JobConfig, atc.ResourceConfigs, atc.ResourceTypes) {
	fake.tryStartPendingBuildsForJobMutex.RLock()
	defer fake.tryStartPendingBuildsForJobMutex.RUnlock()
	return fake.tryStartPendingBuildsForJobArgsForCall[i].logger, fake.tryStartPendingBuildsForJobArgsForCall[i].jobConfig, fake.tryStartPendingBuildsForJobArgsForCall[i].resourceConfigs, fake.tryStartPendingBuildsForJobArgsForCall[i].resourceTypes
}

func (fake *FakeBuildStarter) TryStartPendingBuildsForJobReturns(result1 error) {
	fake.TryStartPendingBuildsForJobStub = nil
	fake.tryStartPendingBuildsForJobReturns = struct {
		result1 error
	}{result1}
}

func (fake *FakeBuildStarter) TryStartAllPendingBuilds(logger lager.Logger, jobConfigs atc.JobConfigs, resourceConfigs atc.ResourceConfigs, resourceTypes atc.ResourceTypes) error {
	fake.tryStartAllPendingBuildsMutex.Lock()
	fake.tryStartAllPendingBuildsArgsForCall = append(fake.tryStartAllPendingBuildsArgsForCall, struct {
		logger          lager.Logger
		jobConfigs      atc.JobConfigs
		resourceConfigs atc.ResourceConfigs
		resourceTypes   atc.ResourceTypes
	}{logger, jobConfigs, resourceConfigs, resourceTypes})
	fake.recordInvocation("TryStartAllPendingBuilds", []interface{}{logger, jobConfigs, resourceConfigs, resourceTypes})
	fake.tryStartAllPendingBuildsMutex.Unlock()
	if fake.TryStartAllPendingBuildsStub != nil {
		return fake.TryStartAllPendingBuildsStub(logger, jobConfigs, resourceConfigs, resourceTypes)
	} else {
		return fake.tryStartAllPendingBuildsReturns.result1
	}
}

func (fake *FakeBuildStarter) TryStartAllPendingBuildsCallCount() int {
	fake.tryStartAllPendingBuildsMutex.RLock()
	defer fake.tryStartAllPendingBuildsMutex.RUnlock()
	return len(fake.tryStartAllPendingBuildsArgsForCall)
}

func (fake *FakeBuildStarter) TryStartAllPendingBuildsArgsForCall(i int) (lager.Logger, atc.JobConfigs, atc.ResourceConfigs, atc.ResourceTypes) {
	fake.tryStartAllPendingBuildsMutex.RLock()
	defer fake.tryStartAllPendingBuildsMutex.RUnlock()
	return fake.tryStartAllPendingBuildsArgsForCall[i].logger, fake.tryStartAllPendingBuildsArgsForCall[i].jobConfigs, fake.tryStartAllPendingBuildsArgsForCall[i].resourceConfigs, fake.tryStartAllPendingBuildsArgsForCall[i].resourceTypes
}

func (fake *FakeBuildStarter) TryStartAllPendingBuildsReturns(result1 error) {
	fake.TryStartAllPendingBuildsStub = nil
	fake.tryStartAllPendingBuildsReturns = struct {
		result1 error
	}{result1}
}

func (fake *FakeBuildStarter) Invocations() map[string][][]interface{} {
	fake.invocationsMutex.RLock()
	defer fake.invocationsMutex.RUnlock()
	fake.tryStartPendingBuildsForJobMutex.RLock()
	defer fake.tryStartPendingBuildsForJobMutex.RUnlock()
	fake.tryStartAllPendingBuildsMutex.RLock()
	defer fake.tryStartAllPendingBuildsMutex.RUnlock()
	return fake.invocations
}

func (fake *FakeBuildStarter) recordInvocation(key string, args []interface{}) {
	fake.invocationsMutex.Lock()
	defer fake.invocationsMutex.Unlock()
	if fake.invocations == nil {
		fake.invocations = map[string][][]interface{}{}
	}
	if fake.invocations[key] == nil {
		fake.invocations[key] = [][]interface{}{}
	}
	fake.invocations[key] = append(fake.invocations[key], args)
}

var _ buildstarter.BuildStarter = new(FakeBuildStarter)
