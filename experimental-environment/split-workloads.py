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

def processing_time_analyzes(parameter):
	"""
	To plot the processing time density chart. It reads as input the workload.json.

	parameter = 1 => delete long jobs
	parameter = 2 => delete short jobs
	""" 
	#max_time = 413.00 #3d_09May
	#max_time = 635.00 #1w_03May
	#max_time = 415.00 #1w_10May
	#max_time = 207.00 #1w_17May
	#max_time = 291.00 #1w_24May
	

	filename = 'workload_original.json'

	with open(filename, 'r') as f:
		datastore = json.load(f)
		f.close()

	if(parameter == 1):
		print(" >>> 		Removing the LONG jobs")
		outfile = 'workload_short.json'
		ids_to_remove = []
		jobs = datastore["jobs"]
		print(len(jobs))
		for job in jobs:
			if((job["real_finish_time"]) > (job["real_start_time"])):
				processing_time = (job["real_finish_time"]) - (job["real_start_time"])
				if(processing_time > max_time):
					ids_to_remove.append(job)
		for ind in ids_to_remove:
			jobs.remove(ind)
		print(len(jobs))
		with open(outfile, "w+") as f:
			f.write(json.dumps(datastore))
			f.close()

	elif(parameter == 2):
		print(" >>> 		Removing the SHORT jobs")
		outfile = 'workload_long.json'
		jobs = datastore["jobs"]
		ids_to_remove = []
		print(len(jobs))
		for job in jobs:
			if((job["real_finish_time"]) > (job["real_start_time"])):
				processing_time = (job["real_finish_time"]) - (job["real_start_time"])
				if(processing_time <= max_time):
					ids_to_remove.append(job)
		for ind in ids_to_remove:
			jobs.remove(ind)
		print(len(jobs))
		with open(outfile, "w+") as f:
			f.write(json.dumps(datastore))
			f.close()

def get_list_jobs(parameter):
	"""
	To plot the processing time density chart. It reads as input the workload.json.

	parameter = 1 => delete long jobs
	parameter = 2 => delete short jobs
	""" 
	#max_time = 413.00 #3d_09May
	#max_time = 635.00 #1w_03May
	#max_time = 415.00 #1w_10May
	#max_time = 207.00 #1w_17May
	#max_time = 291.00 #1w_24May
	

	filename = 'workload_original.json'

	with open(filename, 'r') as f:
		datastore = json.load(f)
		f.close()

	if(parameter == 1):
		print(" >>> 		Getting the LONG jobs")
		outfile = 'workload_short.json'
		ids_list = []
		jobs = datastore["jobs"]
		#print(len(jobs))
		for job in jobs:
			if((job["real_finish_time"]) > (job["real_start_time"])):
				processing_time = (job["real_finish_time"]) - (job["real_start_time"])
				if(processing_time > max_time):
					ids_list.append(job["id"])
		with open('list_long_jobs.csv','w') as f:
			writer = csv.writer(f)
			writer.writerow(["job_id"])
			for id_ in ids_list:
				writer.writerow([id_])

	elif(parameter == 2):
		print(" >>> 		Getting the SHORT jobs")
		outfile = 'workload_long.json'
		jobs = datastore["jobs"]
		ids_list = []
		#print(len(jobs))
		for job in jobs:
			if((job["real_finish_time"]) > (job["real_start_time"])):
				processing_time = (job["real_finish_time"]) - (job["real_start_time"])
				if(processing_time <= max_time):
					ids_list.append(job["id"])
		print(len(ids_list))
		with open('list_short_jobs.csv','w') as f:
			writer = csv.writer(f)
			writer.writerow(["job_id"])
			for id_ in ids_list:
				writer.writerow([id_])


def main():
	#print(" >>> 	Spliting the wokload in short_ and long_")
	#processing_time_analyzes(1)
	#processing_time_analyzes(2)

	print(" >>> 	Getting the list of short_ and long_ jobs")
	get_list_jobs(1)
	get_list_jobs(2)

main()