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

def prepare_file(scheduler, type_job):
	"""
	Receives as input the directories, opens the jobs.csv and remove all data from dyn-burn and dyn-staging jobs,
	then will save it as out_jobs_processed.csv
	if type_job = 'dyn-staging' ==> will save the dyn-staging
	"""
	print("		>>> Cleaning the output_jobs.csv")
	# making data frame from csv file 
	data_frame = pd.read_csv(scheduler + '/out_jobs.csv')
	#print(data_frame)
	# dropping passed values
	#df_dyn_staging = data_frame.loc[data_frame["workload_name"] == "dyn-staging"]
	
	if(type_job == 'dyn-staging'):
		print("		>>> Deleting jobs different of dyn-staging")
		data_frame_cleaned = data_frame[data_frame.workload_name == "dyn-staging"]
	
	else:
		print("		>>> Deleting dyn-staging jobs")
		data_frame_cleaned = data_frame[data_frame.workload_name != "dyn-staging"]
		print("		>>> Deleting dyn-burn jobs")
		data_frame_cleaned = data_frame_cleaned[data_frame_cleaned.workload_name != "dyn-burn"]

	# AllJobs
	data_frame_all_jobs = data_frame_cleaned.copy()
	data_frame_all_jobs.drop(["job_id"], axis = 1)
	data_frame_all_jobs["job_id"] = ""
	data_frame_all_jobs.to_csv(scheduler + '/' + 'out_jobs_processed.csv', sep = ',', index = True)

	# SmallJobs
	data_frame_small_jobs = data_frame_cleaned.copy()
	data_frame_small_jobs = data_frame_small_jobs[data_frame_small_jobs.finish_time - data_frame_small_jobs.starting_time <= 291]
	data_frame_small_jobs.drop(["job_id"], axis = 1)
	data_frame_small_jobs["job_id"] = ""
	data_frame_small_jobs.to_csv(scheduler + '/' + 'out_short_jobs_processed.csv', sep = ',', index = True)
	
	# LongJobs
	data_frame_long_jobs = data_frame_cleaned.copy()
	data_frame_long_jobs = data_frame_long_jobs[data_frame_long_jobs.finish_time - data_frame_long_jobs.starting_time > 291]
	data_frame_long_jobs.drop(["job_id"], axis = 1)
	data_frame_long_jobs["job_id"] = ""
	data_frame_long_jobs.to_csv(scheduler + '/' + 'out_long_jobs_processed.csv', sep = ',', index = True)
	
	
def prepare_file_by_interval_time(scheduler, max_time):
	"""
	Receives as input the directories, opens the jobs.csv and remove all data from dyn-burn and dyn-staging jobs,
	it will also filter the values by the max_time, then will save it as out_jobs_processed.csv
	"""
	
	print("		>>> Cleaning the output_jobs.csv and filtering the submission_time by: " + str(max_time))
	# making data frame from csv file 
	data_frame = pd.read_csv(scheduler + '/out_jobs.csv')
	# dropping passed values
	#df_dyn_staging = data_frame.loc[data_frame["workload_name"] == "dyn-staging"]
	print("		>>> Deleting dyn-staging jobs")
	data_frame_cleaned = data_frame[data_frame.workload_name != "dyn-staging"]
	print("		>>> Deleting dyn-burn jobs")
	data_frame_cleaned = data_frame_cleaned[data_frame_cleaned.workload_name != "dyn-burn"]
	print("		>>> Deleting data for time > " + str(max_time))
	data_frame_cleaned = data_frame_cleaned[data_frame_cleaned.submission_time <= max_time]
	data_frame_cleaned = data_frame_cleaned[data_frame_cleaned.finish_time <= max_time]

	data_frame_cleaned.drop(["job_id"], axis = 1)
	data_frame_cleaned["job_id"] = ""
	data_frame_cleaned.to_csv(scheduler + '/' + 'out_jobs_processed_by_time.csv', sep = ',', index = True)

def prepare_file_metrics(scheduler, size_job):
	"""
	Receives as input the directories, it opens the out_jobs_jobs.csv (jobs without burn and staging) and
	it will compute the waiting_time, slowdown then will save it as out_jobs_times.csv
	"""
  
	#print('data/' + workload_name + '/workload.json')
	#filename = 'out_jobs_processed.csv'
	if(size_job == 1):
		print(scheduler)
		dict_times = {}
		with open(scheduler +"/out_jobs_processed.csv", 'r') as f:
			out_jobs = csv.reader(f)
			
			for row in out_jobs:
				
				# To get the values from the line
				profile = row[3]
				sub_time = row[4]
				final_state = row[8]
				start_time = row[9]
				exec_time = row[10]
				finish_time = row[11]

				if (final_state == 'COMPLETED_SUCCESSFULLY'):

					# This is an re-submitted completed successfully instance.
					if (profile in dict_times.keys()):

						# Should replace the start_time and finish_time, but, should use the sub_time of the first one.
						sub_time = dict_times[profile][0] # The sub_time of the first submission.
						waiting_time = abs(float(start_time) - float(sub_time))
						slowdown = (float(finish_time) - float(sub_time)) / float(exec_time)
						bsd = max (1.0, ((float(waiting_time) + float(exec_time)) / max(1.0,float(exec_time))))

						dict_times[profile][1] = start_time
						dict_times[profile][2] = finish_time
						dict_times[profile][3] = waiting_time
						dict_times[profile][4] = slowdown
						dict_times[profile][5] = bsd
					
					# This is an unique completed successfully instance.
					else:
						waiting_time = abs(float(start_time) - float(sub_time))
						slowdown = (float(finish_time) - float(sub_time)) / float(exec_time)
						bsd = max (1.0, ((float(waiting_time) + float(exec_time)) / max(1.0,float(exec_time))))

						dict_times[profile] = [sub_time, start_time, finish_time, waiting_time, slowdown, bsd]
				
				# This is a completed killed instance, maybe a re-submitted one, or an unique one that was killed and not re-submitted.
				elif (final_state == 'COMPLETED_KILLED'):
					# A killed and not re-submitted one will have -1 at the end because it wont be changed

					# To check if instance it is not a re-submitted instance also completed_killed 
					if (profile not in dict_times.keys()):
						dict_times[profile] = [sub_time, -1, -1, -1, -1, -1]

		job_id = 0
		for item in dict_times:
			dict_times[item].append(job_id)
			job_id += 1
	    
		# To save as csv
		with open(scheduler + '/out_jobs_times.csv','w') as f:
			writer = csv.writer(f)
			writer.writerow(["submission_time", "start_time", "finish_time", "waiting_time", "slow_down", "bsd", "profile_id"])
			for item in dict_times:
				line = [dict_times[item]]
				writer.writerows(line)

	elif(size_job == 2):
		print(scheduler)
		dict_times = {}
		with open(scheduler +"/out_short_jobs_processed.csv", 'r') as f:
			out_jobs = csv.reader(f)
			
			for row in out_jobs:
				
				# To get the values from the line
				profile = row[3]
				sub_time = row[4]
				final_state = row[8]
				start_time = row[9]
				exec_time = row[10]
				finish_time = row[11]

				if (final_state == 'COMPLETED_SUCCESSFULLY'):

					# This is an re-submitted completed successfully instance.
					if (profile in dict_times.keys()):

						# Should replace the start_time and finish_time, but, should use the sub_time of the first one.
						sub_time = dict_times[profile][0] # The sub_time of the first submission.
						waiting_time = abs(float(start_time) - float(sub_time))
						slowdown = (float(finish_time) - float(sub_time)) / float(exec_time)
						bsd = max (1.0, ((float(waiting_time) + float(exec_time)) / max(1.0,float(exec_time))))

						dict_times[profile][1] = start_time
						dict_times[profile][2] = finish_time
						dict_times[profile][3] = waiting_time
						dict_times[profile][4] = slowdown
						dict_times[profile][5] = bsd
					
					# This is an unique completed successfully instance.
					else:
						waiting_time = abs(float(start_time) - float(sub_time))
						slowdown = (float(finish_time) - float(sub_time)) / float(exec_time)
						bsd = max (1.0, ((float(waiting_time) + float(exec_time)) / max(1.0,float(exec_time))))

						dict_times[profile] = [sub_time, start_time, finish_time, waiting_time, slowdown, bsd]
				
				# This is a completed killed instance, maybe a re-submitted one, or an unique one that was killed and not re-submitted.
				elif (final_state == 'COMPLETED_KILLED'):
					# A killed and not re-submitted one will have -1 at the end because it wont be changed

					# To check if instance it is not a re-submitted instance also completed_killed 
					if (profile not in dict_times.keys()):
						dict_times[profile] = [sub_time, -1, -1, -1, -1, -1]

		job_id = 0
		for item in dict_times:
			dict_times[item].append(job_id)
			job_id += 1
    
		# To save as csv
		with open(scheduler + '/out_short_jobs_times.csv','w') as f:
			writer = csv.writer(f)
			writer.writerow(["submission_time", "start_time", "finish_time", "waiting_time", "slow_down", "bsd", "profile_id"])
			for item in dict_times:
				line = [dict_times[item]]
				writer.writerows(line)

	elif(size_job == 3):
		print(scheduler)
		dict_times = {}
		with open(scheduler +"/out_long_jobs_processed.csv", 'r') as f:
			out_jobs = csv.reader(f)
			
			for row in out_jobs:
				
				# To get the values from the line
				profile = row[3]
				sub_time = row[4]
				final_state = row[8]
				start_time = row[9]
				exec_time = row[10]
				finish_time = row[11]

				if (final_state == 'COMPLETED_SUCCESSFULLY'):

					# This is an re-submitted completed successfully instance.
					if (profile in dict_times.keys()):

						# Should replace the start_time and finish_time, but, should use the sub_time of the first one.
						sub_time = dict_times[profile][0] # The sub_time of the first submission.
						waiting_time = abs(float(start_time) - float(sub_time))
						slowdown = (float(finish_time) - float(sub_time)) / float(exec_time)
						bsd = max (1.0, ((float(waiting_time) + float(exec_time)) / max(1.0,float(exec_time))))

						dict_times[profile][1] = start_time
						dict_times[profile][2] = finish_time
						dict_times[profile][3] = waiting_time
						dict_times[profile][4] = slowdown
						dict_times[profile][5] = bsd
					
					# This is an unique completed successfully instance.
					else:
						waiting_time = abs(float(start_time) - float(sub_time))
						slowdown = (float(finish_time) - float(sub_time)) / float(exec_time)
						bsd = max (1.0, ((float(waiting_time) + float(exec_time)) / max(1.0,float(exec_time))))

						dict_times[profile] = [sub_time, start_time, finish_time, waiting_time, slowdown, bsd]
				
				# This is a completed killed instance, maybe a re-submitted one, or an unique one that was killed and not re-submitted.
				elif (final_state == 'COMPLETED_KILLED'):
					# A killed and not re-submitted one will have -1 at the end because it wont be changed

					# To check if instance it is not a re-submitted instance also completed_killed 
					if (profile not in dict_times.keys()):
						dict_times[profile] = [sub_time, -1, -1, -1, -1, -1]

		job_id = 0
		for item in dict_times:
			dict_times[item].append(job_id)
			job_id += 1
    
		# To save as csv
		with open(scheduler + '/out_long_jobs_times.csv','w') as f:
			writer = csv.writer(f)
			writer.writerow(["submission_time", "start_time", "finish_time", "waiting_time", "slow_down", "bsd", "profile_id"])
			for item in dict_times:
				line = [dict_times[item]]
				writer.writerows(line)

def plot_all_charts(scheduler, data_frame, workload_name):
	"""
	Plot the three charts (Gantt chart with te other showing start, submission, finish_time)
	"""
	
	data_frame.plot(with_details=True)
	fig = plt.figure(1)
	visu.gantt.plot_gantt(data_frame, title = 'Gantt chart full' + scheduler)
	
	plt.title('Gantt Chart - detailed \n Scheduler : ' + scheduler)
	plt.savefig('../../analyzes/' + workload_name + '/' + workload_name + '_' + scheduler + '_ganttChart_full.png')
	#plt.show()

def plot_gantt_chart(scheduler, data_frame, workload_name, reduced_by_time, max_time):
	"""
	Plot olny the gantt chart
	"""

	#data_frame.plot(with_details=False)
	fig = plt.figure(1)
	visu.gantt.plot_gantt(data_frame, title = 'Gantt chart: ' + scheduler)
	
	if(reduced_by_time):
		plt.title('Gantt Chart (max_time = '+ str(max_time) + ') \n Scheduler : ' + scheduler)
		plt.savefig('../../analyzes/' + workload_name + '/' + workload_name + '_' + scheduler + '_ganttChart_reduced_by_' + str(max_time) + '.png')
	
	else:
		plt.title('')#Gantt Chart \n Scheduler : ' + scheduler)
		plt.savefig('../../analyzes/' + workload_name + '/' + workload_name + '_' + scheduler + '_ganttChart.png')
	#plt.show()

def plot_gantt_chart_diff(dict_workloads, workload_name):
	"""
	Plot olny the diff between two gantt chart
	"""

	# To shift the charts to zero to be compared.
	for js in dict_workloads.values():
		js.reset_time()

	fig = plt.figure(1)
	visu.plot_diff_gantt(dict_workloads)
	fig.canvas.set_window_title(workload_name + 'diff_job_allocation')
	plt.savefig('../../analyzes/' + workload_name + '/' + workload_name + '_' + 'diff_ganttChart.png')
	#plt.show()

def data_sets_analyzes(workload_name):
	"""
	To plot the data sets analyzes: the bar chart for the data sets dependency.
	It also saves the data computed as data_sets_dependencies.csv
	""" 

	filename = 'workload.json'

	with open(filename, 'r') as f:
	    datastore = json.load(f)

	datasets_list = {}
	datasets_list['empty'] = 0

	executed_jobs = []
	jobs = datastore["jobs"]
	for job in jobs:
		executed_jobs.append(job["profile"])
	print(len(executed_jobs))
    
	# To access the profiles
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

    # To plot the data (pie-plot)
	fig, ax = plt.subplots()
	rects = ax.bar(data_set_id, datasets_list.values())
	ax.set_ylabel('Number of instances') 
	ax.set_xlabel('Data set IDs') 
	ax.set_title('Number of jobs using the same data sets: \n\n Number of data_sets: ' + str(len(datasets_list)) + 
			'\n Number of instances: ' + str(len(executed_jobs))) 
	
	#xpos = xpos.lower()
	#for rect in rects:
	#	height = rect.get_height()
	#	ax.text(rect.get_x(), 1.01*height, '{}'.format(height), va='bottom')
	plt.savefig('../../analyzes/' + workload_name + '/' + workload_name + '_' + 'data_sets_dependencies.png')
	#plt.show()
    
	# To save as csv
	with open('../../analyzes/' + workload_name + '/' + workload_name + '_' + 'data_sets_dependencies.csv','w') as f:
		writer = csv.writer(f)
		writer.writerow(["data_sets_id", "number_requirements"])
		writer.writerows(datasets_list.items())

def filter_staging_jobs(workload_name):
	"""
	To plot the data sets analyzes: the bar chart for the data sets dependency.
	It also saves the data computed as data_sets_dependencies.csv
	""" 

	filename = 'workload.json'

	with open(filename, 'r') as f:
	    datastore = json.load(f)

	datasets_list = {}
	datasets_list['empty'] = 0

	executed_jobs = []
	jobs = datastore["jobs"]
	for job in jobs:
		executed_jobs.append(job["profile"])
	print(len(executed_jobs))

	print("		>>> Cleaning the staging_jobs.csv")
	# making data frame from csv file 
	data_frame = pd.read_csv(scheduler + '/staging_jobs.csv')
	# dropping passed values
	#df_dyn_staging = data_frame.loc[data_frame["workload_name"] == "dyn-staging"]
	
	if(type_job == 'dyn-staging'):
		print("		>>> Deleting jobs different of dyn-staging")
		data_frame_cleaned = data_frame[data_frame.workload_name == "dyn-staging"]
	
	else:
		print("		>>> Deleting dyn-staging jobs")
		data_frame_cleaned = data_frame[data_frame.workload_name != "dyn-staging"]
		print("		>>> Deleting dyn-burn jobs")
		data_frame_cleaned = data_frame_cleaned[data_frame_cleaned.workload_name != "dyn-burn"]
	
	data_frame_cleaned.drop(["job_id"], axis = 1)
	data_frame_cleaned["job_id"] = ""
	data_frame_cleaned.to_csv(scheduler + '/' + 'out_jobs_processed.csv', sep = ',', index = True)



def main():
	print(" >>> 	Analyzing the jobs")

	schedulers = ['qarnotNodeSched', 'qarnotNodeSchedAndrei', 'qarnotNodeSchedReplicate3LeastLoaded', 'qarnotNodeSchedReplicate10LeastLoaded', 'qarnotNodeSchedFullReplicate']
	#schedulers2 = ["standard_scheduler", "locationBased_scheduler", "replicate3LeastLoaded_scheduler", "replicate10LeastLoaded_scheduler"]
	
	#schedulers = ['qarnotNodeSched', 'qarnotNodeSchedStatic']

	max_time = 200000
	jobsets = {}
	jobsets_time_interval = {}
	current_dir = os.getcwd()
	workload_name = current_dir.split('/')[-1]
	
	print("		>>>	Workload: " + workload_name)
	
	for scheduler in schedulers:
		
		max_time = 200000

		# To remove the burn and staging jobs
		prepare_file(scheduler, 'jobs')

		# To keep only the staging jobs
		#prepare_file(scheduler, 'dyn-staging')

		# To plot several gantt charts together
		jobs = JobSet.from_csv(scheduler + "/out_jobs_processed.csv")
		jobsets[scheduler] = jobs
		
		# To remove the burn and staging jobs and filter by max_time
		#prepare_file_by_interval_time(scheduler, 200000)
		#jobs_time_interval = JobSet.from_csv(scheduler + "/out_jobs_processed_by_time.csv")
		#jobsets_time_interval[scheduler] = jobs_time_interval
		
		#To plot the Gantt charts
		
		# 		To plot the full Gantt Chart (3 graphs)
		#plot_all_charts(scheduler, jobs)
		
		#		It plots the simple GanttChart
		#plot_gantt_chart(scheduler, jobs, workload_name, 0, max_time)
		
		#		It plots the simple GanttChart looking for jobs with finish_time reduced by max_time
		#plot_gantt_chart(scheduler, jobs_time_interval, workload_name, 1, max_time)
		
		# To compute the waiting_time and slowdown for the real jobs
		prepare_file_metrics(scheduler, 1)
		prepare_file_metrics(scheduler, 2)
		prepare_file_metrics(scheduler, 3)

		# To plot the data sets dependencies
		data_sets_analyzes(workload_name) # Bar chart

	# To plot the Gantt Chart diff with all workloads
	#plot_gantt_chart_diff(jobsets, workload_name)

main()