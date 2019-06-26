#!/usr/bin/python3

from evalys.jobset import JobSet
from evalys.workload import Workload
from evalys import visu
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import os
import json
import numpy as np
import csv


def processing_time_boxplots(workloads, size):
	"""
	To plot the processing time density chart. It reads as input the workload.json.
	""" 

	df_proc_time = []
	summary = []
	for workload_name in workloads:
		print(workload_name)
		filename = 'output/' + workload_name + '/workload.json'
		with open(filename, 'r') as f:
			datastore = json.load(f)

		job_process_time = {}

		# To access the jobs data
		jobs = datastore["jobs"]
		for job in jobs:
			#if(len(job) == 8):
			if((job["real_finish_time"]) >= (job["real_start_time"]) and (job["subtime"] != -1)):
				job_process_time[job["id"]] = (job["real_finish_time"]) - (job["real_start_time"])

		# To pre-process the data to plot
		jobs = []
		proc_time = []
		for j in job_process_time:
			proc_time.append(job_process_time[j])
		jobs = range(1, len(proc_time))
		df_proc_time.append(proc_time)
	
	# Boxplot
	fig, ax = plt.subplots()
	title = fig.suptitle("QJobs processing time" , fontsize=14)
	ax.set_xlabel(" Workloads (s)")
	ax.set_ylabel(" Time (s) ")
	#ax.boxplot(df_proc_time, showfliers = False )
	ax = sns.boxplot(data=df_proc_time)#,  showfliers=False)
	ax.set_xticklabels(workloads)
	ax.annotate(str(summary), xy=(400, 200), xycoords='figure pixels')
	if (size == 0):
		fig.savefig('processing_time_jobs_density_outliers.png')
	if (size == 1):
		fig.savefig('processing_time_long_jobs_density_outliers.png')
	elif (size == 2):
		fig.savefig('processing_time_short_jobs_density_outliers.png')

def processing_time_barplots(workloads, size):
	"""
	To plot the processing time density chart. It reads as input the workload.json.
	""" 

	df_proc_time = []
	summary = []
	for workload_name in workloads:
		print(workload_name)
		filename = 'output/' + workload_name + '/workload.json'
		with open(filename, 'r') as f:
			datastore = json.load(f)

		job_process_time = {}

		# To access the jobs data
		jobs = datastore["jobs"]
		for job in jobs:
			#if(len(job) == 8):
			if((job["real_finish_time"]) >= (job["real_start_time"]) and (job["subtime"] != -1)):
				job_process_time[job["id"]] = (job["real_finish_time"]) - (job["real_start_time"])

		# To pre-process the data to plot
		jobs = []
		proc_time = []
		for j in job_process_time:
			proc_time.append(float(job_process_time[j]))
		jobs = range(1, len(proc_time)+1)
	
		# Bar Plot
		fig, ax = plt.subplots()
		title = fig.suptitle("Intances processing time" , fontsize=14)
		ax.set_xlabel(" Instance ID ")
		ax.set_ylabel(" Processing Time (s) ")
		#ax.boxplot(df_proc_time, showfliers = False )
		#ax = sns.distplot(proc_time, bins = 2000)
		ordered = sorted(proc_time)
		#print(ordered)
		ax = plt.bar(jobs,ordered)
		#ax = plt.bar(proc_time, jobs )
		#ax = sns.boxplot(data=df_proc_time)#,  showfliers=False)
		#ax.set_xticklabels(workloads)
		#ax.annotate(str(summary), xy=(400, 200), xycoords='figure pixels')
		if (size == 0):
			fig.savefig('processing_time_jobs_density_outliers' + workload_name + '.png')
		if (size == 1):
			fig.savefig('processing_time_long_jobs_density_outliers' + workload_name + '.png')
		elif (size == 2):
			fig.savefig('processing_time_short_jobs_density_outliers' + workload_name +  '.png')

def data_sets_boxplots(workloads, size):
	"""
	To plot the data sets analyzes: the bar chart for the data sets dependency.
	It also saves the data computed as data_sets_dependencies.csv
	""" 
	df_dataset_dependency = []
	summary = []
	for workload_name in workloads:
		print(workload_name)
		filename = 'output/' + workload_name + '/workload.json'
		with open(filename, 'r') as f:
		    datastore = json.load(f)

		datasets_list = {}
		datasets_list['empty'] = 0
	    
		# To access the profiles
		executed_jobs = []
		jobs = datastore["jobs"]
		for job in jobs:
			#if(len(job) == 8):
			executed_jobs.append(job["profile"])
		print(len(executed_jobs))

		profiles = datastore["profiles"]
		for profile in profiles:
			if(profiles[profile]["datasets"] == None):
				datasets_list['empty'] = datasets_list['empty'] + 1
			elif(profile in executed_jobs):
				list_data_sets = list(profiles[profile]["datasets"])
				for data_set in list_data_sets:
					if(datasets_list.get(data_set) != None) :
						datasets_list[data_set] = datasets_list[data_set] + 1
					else:
						datasets_list[data_set] = 1
	                    
		data_set_id = range(1, len(datasets_list.keys())+1)

		# To pre-process the data to plot
		datasets = []
		dependency = []
		for ds in datasets_list:
			dependency.append(datasets_list[ds])
		ds = range(1, len(datasets_list))
		df_dataset_dependency.append(dependency)


	# Boxplots
	fig, ax = plt.subplots()
	title = fig.suptitle("Distribution of instances using the same data set" , fontsize=14)
	ax.set_xlabel(" Workloads (s)")
	ax.set_ylabel(" Number of instances")
	#ax.boxplot(df_proc_time, showfliers = False )
	ax = sns.boxplot(data=df_dataset_dependency)#,  showfliers=False)
	ax.set_xticklabels(workloads)
	#ax.annotate(str(summary), xy=(400, 200), xycoords='figure pixels')
	if (size == 0):
		fig.savefig('ds_density.png')
	if (size == 1):
		fig.savefig('ds_density_long_jobs.png')
	elif (size == 2):
		fig.savefig('ds_density_short_jobs.png')

def main():
	print(" >>> 	Analyzing the workloads: + workloads")

	workloads = ['1w_03-05-2019', '1w_10-05-2019', '1w_17-05-2019', '1w_24-05-2019']
	#workloads_long = ['1w_03-05-2019_long', '1w_10-05-2019_long', '1w_17-05-2019_long', '1w_24-05-2019_long'] 
	#workloads_short = ['1w_03-05-2019_short', '1w_10-05-2019_short', '1w_17-05-2019_short', '1w_24-05-2019_short']

	schedulers = ['qarnotNodeSched', 'qarnotNodeSchedAndrei', 'qarnotNodeSchedFullReplicate', 'qarnotNodeSchedReplicate3LeastLoaded', 'qarnotNodeSchedReplicate10LeastLoaded']

	#processing_time_boxplots(workloads, 0)	
	#processing_time_boxplots(workloads_long, 1)
	#processing_time_boxplots(workloads_short, 2)

	processing_time_barplots(workloads, 0)
	#processing_time_barplots(workloads_long, 1)
	#processing_time_barplots(workloads_short, 2)

	data_sets_boxplots(workloads, 0)	
	#data_sets_boxplots(workloads_long, 1)	
	#data_sets_boxplots(workloads_short, 2)	

main()