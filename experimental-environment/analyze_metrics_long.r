#!/usr/bin/env Rscript

library(dplyr)
library(reshape2)
library(ggplot2)
library(ggpubr)
library(tidyr)
library(stats)
library(RColorBrewer)
library(gridExtra)

# To read the input files

# out_schedule.csv
schedule_standard <- read.csv("output/1w_03-05-2019/qarnotNodeSched/out_schedule.csv", header=T,strip.white=TRUE);
schedule_location_based <- read.csv("output/1w_03-05-2019/qarnotNodeSchedAndrei/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate3LeastLoaded <- read.csv("output/1w_03-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate10LeastLoaded <- read.csv("output/1w_03-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_fullrep <- read.csv("output/1w_03-05-2019/qarnotNodeSchedFullReplicate/out_schedule.csv", header=T,strip.white=TRUE);

# out_pybatsim.csv
schedule_plus_standard <- read.csv("output/1w_03-05-2019/qarnotNodeSched/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_location_based <- read.csv("output/1w_03-05-2019/qarnotNodeSchedAndrei/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate3LeastLoaded <- read.csv("output/1w_03-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate10LeastLoaded <- read.csv("output/1w_03-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_fullrep <- read.csv("output/1w_03-05-2019/qarnotNodeSchedFullReplicate/out_pybatsim.csv", header=T,strip.white=TRUE);

# out_long_jobs_times.csv
jobs_time_standard <- read.csv("output/1w_03-05-2019/qarnotNodeSched/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_location_based <- read.csv("output/1w_03-05-2019/qarnotNodeSchedAndrei/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate3LeastLoaded <- read.csv("output/1w_03-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate10LeastLoaded <- read.csv("output/1w_03-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_fullrep <- read.csv("output/1w_03-05-2019/qarnotNodeSchedFullReplicate/out_long_jobs_times.csv", header=T,strip.white=TRUE);

jobs_time_standard <- jobs_time_standard %>% filter(jobs_time_standard$start_time != -1)
jobs_time_location_based <- jobs_time_location_based %>% filter(jobs_time_location_based$start_time != -1)
jobs_time_replicate3LeastLoaded <- jobs_time_replicate3LeastLoaded %>% filter(jobs_time_replicate3LeastLoaded$start_time != -1)
jobs_time_replicate10LeastLoaded <- jobs_time_replicate10LeastLoaded %>% filter(jobs_time_replicate10LeastLoaded$start_time != -1)
jobs_time_fullrep <- jobs_time_fullrep %>% filter(jobs_time_fullrep$start_time != -1)

# To add a column for the Scheduler name
schedule_standard$Scheduler <- "Standard"
schedule_location_based$Scheduler <- "LocalityBased"
schedule_replicate3LeastLoaded$Scheduler <- "Replicate3"
schedule_replicate10LeastLoaded$Scheduler <- "Replicate10"
schedule_fullrep$Scheduler <- "FullReplicate"

# To compute and save the max_ and the mean_ waiting time
max_waiting_time_standard <- max(jobs_time_standard$waiting_time)
max_waiting_time_location_based <- max(jobs_time_location_based$waiting_time)
max_waiting_time_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$waiting_time)
max_waiting_time_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$waiting_time)
max_waiting_time_fullrep <- max(jobs_time_fullrep$waiting_time)

schedule_standard$max_waiting_time <- max_waiting_time_standard
schedule_location_based$max_waiting_time <- max_waiting_time_location_based
schedule_replicate3LeastLoaded$max_waiting_time <- max_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_waiting_time <- max_waiting_time_replicate10LeastLoaded
schedule_fullrep$max_waiting_time <- max_waiting_time_fullrep

mean_waiting_time_standard <- mean(jobs_time_standard$waiting_time)
mean_waiting_time_location_based <- mean(jobs_time_location_based$waiting_time)
mean_waiting_time_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$waiting_time)
mean_waiting_time_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$waiting_time)
mean_waiting_time_fullrep <- mean(jobs_time_fullrep$waiting_time)

schedule_standard$mean_waiting_time <- mean_waiting_time_standard
schedule_location_based$mean_waiting_time <- mean_waiting_time_location_based
schedule_replicate3LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate10LeastLoaded
schedule_fullrep$mean_waiting_time <- mean_waiting_time_fullrep


# To compute and save the max_ and the mean_ slowdown
max_slow_down_standard <- max(jobs_time_standard$slow_down)
max_slow_down_location_based <- max(jobs_time_location_based$slow_down)
max_slow_down_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$slow_down)
max_slow_down_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$slow_down)
max_slow_down_fullrep <- max(jobs_time_fullrep$slow_down)

schedule_standard$max_slow_down <- max_slow_down_standard
schedule_location_based$max_slow_down <- max_slow_down_location_based
schedule_replicate3LeastLoaded$max_slow_down <- max_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_slow_down <- max_slow_down_replicate10LeastLoaded
schedule_fullrep$max_slow_down <- max_slow_down_fullrep

mean_slow_down_standard <- mean(jobs_time_standard$slow_down)
mean_slow_down_location_based <- mean(jobs_time_location_based$slow_down)
mean_slow_down_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$slow_down)
mean_slow_down_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$slow_down)
mean_slow_down_fullrep <- mean(jobs_time_fullrep$slow_down)

schedule_standard$mean_slow_down <- mean_slow_down_standard
schedule_location_based$mean_slow_down <- mean_slow_down_location_based
schedule_replicate3LeastLoaded$mean_slow_down <- mean_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_slow_down <- mean_slow_down_replicate10LeastLoaded
schedule_fullrep$mean_slow_down <- mean_slow_down_fullrep


# To compute the max and mean of bounded slowdown
max_bsd_standard <- max(jobs_time_standard$bsd)
max_bsd_location_based <- max(jobs_time_location_based$bsd)
max_bsd_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$bsd)
max_bsd_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$bsd)
max_bsd_fullrep <- max(jobs_time_fullrep$bsd)

schedule_standard$max_bsd <- max_bsd_standard
schedule_location_based$max_bsd <- max_bsd_location_based
schedule_replicate3LeastLoaded$max_bsd <- max_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_bsd <- max_bsd_replicate10LeastLoaded
schedule_fullrep$max_bsd <- max_bsd_fullrep

mean_bsd_standard <- mean(jobs_time_standard$bsd)
mean_bsd_location_based <- mean(jobs_time_location_based$bsd)
mean_bsd_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$bsd)
mean_bsd_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$bsd)
mean_bsd_fullrep <- mean(jobs_time_fullrep$bsd)

schedule_standard$mean_bsd <- mean_bsd_standard
schedule_location_based$mean_bsd <- mean_bsd_location_based
schedule_replicate3LeastLoaded$mean_bsd <- mean_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_bsd <- mean_bsd_replicate10LeastLoaded
schedule_fullrep$mean_bsd <- mean_bsd_fullrep

# To bind the _schedules with the _schedule_plus
schedule_standard_full <- bind_cols(schedule_standard, schedule_plus_standard)
schedule_location_based_full <- bind_cols(schedule_location_based, schedule_plus_location_based)
schedule_replicate3LeastLoaded_full <- bind_cols(schedule_replicate3LeastLoaded, schedule_plus_replicate3LeastLoaded)
schedule_replicate10LeastLoaded_full <- bind_cols(schedule_replicate10LeastLoaded, schedule_plus_replicate10LeastLoaded)
schedule_fullrep_full <- bind_cols(schedule_fullrep, schedule_plus_fullrep)

df_all_1w_03 <- rbind(schedule_standard_full, schedule_location_based_full, schedule_replicate3LeastLoaded_full, schedule_replicate10LeastLoaded_full, schedule_fullrep_full)

df_all_1w_03$consumed_joules <- df_all_1w_03$consumed_joules / 100000000
#df_all_1w_03$total_data_transfer <- df_all_1w_03$total_data_transfer / 1000000000

df_all_gathered_1w_03 <- gather(df_all_1w_03, 
                          factor_key = TRUE, 
                          key = "metrics", 
                          value = "values",
                          -batsim_version, -Scheduler)

df_all_gathered_1w_03$Workload <- '1w_03'


# To read the input files

# out_schedule.csv
schedule_standard <- read.csv("output/1w_10-05-2019/qarnotNodeSched/out_schedule.csv", header=T,strip.white=TRUE);
schedule_location_based <- read.csv("output/1w_10-05-2019/qarnotNodeSchedAndrei/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate3LeastLoaded <- read.csv("output/1w_10-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate10LeastLoaded <- read.csv("output/1w_10-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_fullrep <- read.csv("output/1w_10-05-2019/qarnotNodeSchedFullReplicate/out_schedule.csv", header=T,strip.white=TRUE);

# out_pybatsim.csv
schedule_plus_standard <- read.csv("output/1w_10-05-2019/qarnotNodeSched/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_location_based <- read.csv("output/1w_10-05-2019/qarnotNodeSchedAndrei/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate3LeastLoaded <- read.csv("output/1w_10-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate10LeastLoaded <- read.csv("output/1w_10-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_fullrep <- read.csv("output/1w_10-05-2019/qarnotNodeSchedFullReplicate/out_pybatsim.csv", header=T,strip.white=TRUE);

# out_long_jobs_times.csv
jobs_time_standard <- read.csv("output/1w_10-05-2019/qarnotNodeSched/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_location_based <- read.csv("output/1w_10-05-2019/qarnotNodeSchedAndrei/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate3LeastLoaded <- read.csv("output/1w_10-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate10LeastLoaded <- read.csv("output/1w_10-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_fullrep <- read.csv("output/1w_10-05-2019/qarnotNodeSchedFullReplicate/out_long_jobs_times.csv", header=T,strip.white=TRUE);

jobs_time_standard <- jobs_time_standard %>% filter(jobs_time_standard$start_time != -1)
jobs_time_location_based <- jobs_time_location_based %>% filter(jobs_time_location_based$start_time != -1)
jobs_time_replicate3LeastLoaded <- jobs_time_replicate3LeastLoaded %>% filter(jobs_time_replicate3LeastLoaded$start_time != -1)
jobs_time_replicate10LeastLoaded <- jobs_time_replicate10LeastLoaded %>% filter(jobs_time_replicate10LeastLoaded$start_time != -1)
jobs_time_fullrep <- jobs_time_fullrep %>% filter(jobs_time_fullrep$start_time != -1)

# To add a column for the Scheduler name
schedule_standard$Scheduler <- "Standard"
schedule_location_based$Scheduler <- "LocalityBased"
schedule_replicate3LeastLoaded$Scheduler <- "Replicate3"
schedule_replicate10LeastLoaded$Scheduler <- "Replicate10"
schedule_fullrep$Scheduler <- "FullReplicate"

# To compute and save the max_ and the mean_ waiting time
max_waiting_time_standard <- max(jobs_time_standard$waiting_time)
max_waiting_time_location_based <- max(jobs_time_location_based$waiting_time)
max_waiting_time_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$waiting_time)
max_waiting_time_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$waiting_time)
max_waiting_time_fullrep <- max(jobs_time_fullrep$waiting_time)

schedule_standard$max_waiting_time <- max_waiting_time_standard
schedule_location_based$max_waiting_time <- max_waiting_time_location_based
schedule_replicate3LeastLoaded$max_waiting_time <- max_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_waiting_time <- max_waiting_time_replicate10LeastLoaded
schedule_fullrep$max_waiting_time <- max_waiting_time_fullrep



mean_waiting_time_standard <- mean(jobs_time_standard$waiting_time)
mean_waiting_time_location_based <- mean(jobs_time_location_based$waiting_time)
mean_waiting_time_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$waiting_time)
mean_waiting_time_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$waiting_time)
mean_waiting_time_fullrep <- mean(jobs_time_fullrep$waiting_time)

schedule_standard$mean_waiting_time <- mean_waiting_time_standard
schedule_location_based$mean_waiting_time <- mean_waiting_time_location_based
schedule_replicate3LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate10LeastLoaded
schedule_fullrep$mean_waiting_time <- mean_waiting_time_fullrep


# To compute and save the max_ and the mean_ slowdown
max_slow_down_standard <- max(jobs_time_standard$slow_down)
max_slow_down_location_based <- max(jobs_time_location_based$slow_down)
max_slow_down_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$slow_down)
max_slow_down_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$slow_down)
max_slow_down_fullrep <- max(jobs_time_fullrep$slow_down)

schedule_standard$max_slow_down <- max_slow_down_standard
schedule_location_based$max_slow_down <- max_slow_down_location_based
schedule_replicate3LeastLoaded$max_slow_down <- max_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_slow_down <- max_slow_down_replicate10LeastLoaded
schedule_fullrep$max_slow_down <- max_slow_down_fullrep

mean_slow_down_standard <- mean(jobs_time_standard$slow_down)
mean_slow_down_location_based <- mean(jobs_time_location_based$slow_down)
mean_slow_down_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$slow_down)
mean_slow_down_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$slow_down)
mean_slow_down_fullrep <- mean(jobs_time_fullrep$slow_down)

schedule_standard$mean_slow_down <- mean_slow_down_standard
schedule_location_based$mean_slow_down <- mean_slow_down_location_based
schedule_replicate3LeastLoaded$mean_slow_down <- mean_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_slow_down <- mean_slow_down_replicate10LeastLoaded
schedule_fullrep$mean_slow_down <- mean_slow_down_fullrep


# To compute the max and mean of bounded slowdown
max_bsd_standard <- max(jobs_time_standard$bsd)
max_bsd_location_based <- max(jobs_time_location_based$bsd)
max_bsd_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$bsd)
max_bsd_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$bsd)
max_bsd_fullrep <- max(jobs_time_fullrep$bsd)

schedule_standard$max_bsd <- max_bsd_standard
schedule_location_based$max_bsd <- max_bsd_location_based
schedule_replicate3LeastLoaded$max_bsd <- max_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_bsd <- max_bsd_replicate10LeastLoaded
schedule_fullrep$max_bsd <- max_bsd_fullrep

mean_bsd_standard <- mean(jobs_time_standard$bsd)
mean_bsd_location_based <- mean(jobs_time_location_based$bsd)
mean_bsd_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$bsd)
mean_bsd_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$bsd)
mean_bsd_fullrep <- mean(jobs_time_fullrep$bsd)

schedule_standard$mean_bsd <- mean_bsd_standard
schedule_location_based$mean_bsd <- mean_bsd_location_based
schedule_replicate3LeastLoaded$mean_bsd <- mean_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_bsd <- mean_bsd_replicate10LeastLoaded
schedule_fullrep$mean_bsd <- mean_bsd_fullrep


# To bind the _schedules with the _schedule_plus
schedule_standard_full <- bind_cols(schedule_standard, schedule_plus_standard)
schedule_location_based_full <- bind_cols(schedule_location_based, schedule_plus_location_based)
schedule_replicate3LeastLoaded_full <- bind_cols(schedule_replicate3LeastLoaded, schedule_plus_replicate3LeastLoaded)
schedule_replicate10LeastLoaded_full <- bind_cols(schedule_replicate10LeastLoaded, schedule_plus_replicate10LeastLoaded)
schedule_fullrep_full <- bind_cols(schedule_fullrep, schedule_plus_fullrep)



df_all_1w_10 <- rbind(schedule_standard_full, schedule_location_based_full, schedule_replicate3LeastLoaded_full, schedule_replicate10LeastLoaded_full, schedule_fullrep_full)

df_all_1w_10$consumed_joules <- df_all_1w_10$consumed_joules / 100000000
#df_all_1w_10$total_data_transfer <- df_all_1w_10$total_data_transfer / 1000000000

df_all_gathered_1w_10 <- gather(df_all_1w_10, 
                          factor_key = TRUE, 
                          key = "metrics", 
                          value = "values",
                          -batsim_version, -Scheduler)

df_all_gathered_1w_10$Workload <- '1w_10'


# To read the input files

# out_schedule.csv
schedule_standard <- read.csv("output/1w_17-05-2019/qarnotNodeSched/out_schedule.csv", header=T,strip.white=TRUE);
schedule_location_based <- read.csv("output/1w_17-05-2019/qarnotNodeSchedAndrei/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate3LeastLoaded <- read.csv("output/1w_17-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate10LeastLoaded <- read.csv("output/1w_17-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_fullrep <- read.csv("output/1w_17-05-2019/qarnotNodeSchedFullReplicate/out_schedule.csv", header=T,strip.white=TRUE);

# out_pybatsim.csv
schedule_plus_standard <- read.csv("output/1w_17-05-2019/qarnotNodeSched/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_location_based <- read.csv("output/1w_17-05-2019/qarnotNodeSchedAndrei/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate3LeastLoaded <- read.csv("output/1w_17-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate10LeastLoaded <- read.csv("output/1w_17-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_fullrep <- read.csv("output/1w_17-05-2019/qarnotNodeSchedFullReplicate/out_pybatsim.csv", header=T,strip.white=TRUE);

# out_long_jobs_times.csv
jobs_time_standard <- read.csv("output/1w_17-05-2019/qarnotNodeSched/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_location_based <- read.csv("output/1w_17-05-2019/qarnotNodeSchedAndrei/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate3LeastLoaded <- read.csv("output/1w_17-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate10LeastLoaded <- read.csv("output/1w_17-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_fullrep <- read.csv("output/1w_17-05-2019/qarnotNodeSchedFullReplicate/out_long_jobs_times.csv", header=T,strip.white=TRUE);

jobs_time_standard <- jobs_time_standard %>% filter(jobs_time_standard$start_time != -1)
jobs_time_location_based <- jobs_time_location_based %>% filter(jobs_time_location_based$start_time != -1)
jobs_time_replicate3LeastLoaded <- jobs_time_replicate3LeastLoaded %>% filter(jobs_time_replicate3LeastLoaded$start_time != -1)
jobs_time_replicate10LeastLoaded <- jobs_time_replicate10LeastLoaded %>% filter(jobs_time_replicate10LeastLoaded$start_time != -1)
jobs_time_fullrep <- jobs_time_fullrep %>% filter(jobs_time_fullrep$start_time != -1)

# To add a column for the Scheduler name
schedule_standard$Scheduler <- "Standard"
schedule_location_based$Scheduler <- "LocalityBased"
schedule_replicate3LeastLoaded$Scheduler <- "Replicate3"
schedule_replicate10LeastLoaded$Scheduler <- "Replicate10"
schedule_fullrep$Scheduler <- "FullReplicate"

# To compute and save the max_ and the mean_ waiting time
max_waiting_time_standard <- max(jobs_time_standard$waiting_time)
max_waiting_time_location_based <- max(jobs_time_location_based$waiting_time)
max_waiting_time_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$waiting_time)
max_waiting_time_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$waiting_time)
max_waiting_time_fullrep <- max(jobs_time_fullrep$waiting_time)

schedule_standard$max_waiting_time <- max_waiting_time_standard
schedule_location_based$max_waiting_time <- max_waiting_time_location_based
schedule_replicate3LeastLoaded$max_waiting_time <- max_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_waiting_time <- max_waiting_time_replicate10LeastLoaded
schedule_fullrep$max_waiting_time <- max_waiting_time_fullrep

mean_waiting_time_standard <- mean(jobs_time_standard$waiting_time)
mean_waiting_time_location_based <- mean(jobs_time_location_based$waiting_time)
mean_waiting_time_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$waiting_time)
mean_waiting_time_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$waiting_time)
mean_waiting_time_fullrep <- mean(jobs_time_fullrep$waiting_time)

schedule_standard$mean_waiting_time <- mean_waiting_time_standard
schedule_location_based$mean_waiting_time <- mean_waiting_time_location_based
schedule_replicate3LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate10LeastLoaded
schedule_fullrep$mean_waiting_time <- mean_waiting_time_fullrep


# To compute and save the max_ and the mean_ slowdown
max_slow_down_standard <- max(jobs_time_standard$slow_down)
max_slow_down_location_based <- max(jobs_time_location_based$slow_down)
max_slow_down_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$slow_down)
max_slow_down_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$slow_down)
max_slow_down_fullrep <- max(jobs_time_fullrep$slow_down)

schedule_standard$max_slow_down <- max_slow_down_standard
schedule_location_based$max_slow_down <- max_slow_down_location_based
schedule_replicate3LeastLoaded$max_slow_down <- max_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_slow_down <- max_slow_down_replicate10LeastLoaded
schedule_fullrep$max_slow_down <- max_slow_down_fullrep

mean_slow_down_standard <- mean(jobs_time_standard$slow_down)
mean_slow_down_location_based <- mean(jobs_time_location_based$slow_down)
mean_slow_down_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$slow_down)
mean_slow_down_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$slow_down)
mean_slow_down_fullrep <- mean(jobs_time_fullrep$slow_down)

schedule_standard$mean_slow_down <- mean_slow_down_standard
schedule_location_based$mean_slow_down <- mean_slow_down_location_based
schedule_replicate3LeastLoaded$mean_slow_down <- mean_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_slow_down <- mean_slow_down_replicate10LeastLoaded
schedule_fullrep$mean_slow_down <- mean_slow_down_fullrep


# To compute the max and mean of bounded slowdown
max_bsd_standard <- max(jobs_time_standard$bsd)
max_bsd_location_based <- max(jobs_time_location_based$bsd)
max_bsd_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$bsd)
max_bsd_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$bsd)
max_bsd_fullrep <- max(jobs_time_fullrep$bsd)

schedule_standard$max_bsd <- max_bsd_standard
schedule_location_based$max_bsd <- max_bsd_location_based
schedule_replicate3LeastLoaded$max_bsd <- max_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_bsd <- max_bsd_replicate10LeastLoaded
schedule_fullrep$max_bsd <- max_bsd_fullrep

mean_bsd_standard <- mean(jobs_time_standard$bsd)
mean_bsd_location_based <- mean(jobs_time_location_based$bsd)
mean_bsd_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$bsd)
mean_bsd_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$bsd)
mean_bsd_fullrep <- mean(jobs_time_fullrep$bsd)

schedule_standard$mean_bsd <- mean_bsd_standard
schedule_location_based$mean_bsd <- mean_bsd_location_based
schedule_replicate3LeastLoaded$mean_bsd <- mean_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_bsd <- mean_bsd_replicate10LeastLoaded
schedule_fullrep$mean_bsd <- mean_bsd_fullrep

# To bind the _schedules with the _schedule_plus
schedule_standard_full <- bind_cols(schedule_standard, schedule_plus_standard)
schedule_location_based_full <- bind_cols(schedule_location_based, schedule_plus_location_based)
schedule_replicate3LeastLoaded_full <- bind_cols(schedule_replicate3LeastLoaded, schedule_plus_replicate3LeastLoaded)
schedule_replicate10LeastLoaded_full <- bind_cols(schedule_replicate10LeastLoaded, schedule_plus_replicate10LeastLoaded)
schedule_fullrep_full <- bind_cols(schedule_fullrep, schedule_plus_fullrep)



df_all_1w_17 <- rbind(schedule_standard_full, schedule_location_based_full, schedule_replicate3LeastLoaded_full, schedule_replicate10LeastLoaded_full, schedule_fullrep_full)

df_all_1w_17$consumed_joules <- df_all_1w_17$consumed_joules / 100000000
#df_all_1w_17$total_data_transfer <- df_all_1w_17$total_data_transfer / 1000000000

df_all_gathered_1w_17 <- gather(df_all_1w_17, 
                          factor_key = TRUE, 
                          key = "metrics", 
                          value = "values",
                          -batsim_version, -Scheduler)

df_all_gathered_1w_17$Workload <- '1w_17'




# To read the input files

# out_schedule.csv
schedule_standard <- read.csv("output/1w_24-05-2019/qarnotNodeSched/out_schedule.csv", header=T,strip.white=TRUE);
schedule_location_based <- read.csv("output/1w_24-05-2019/qarnotNodeSchedAndrei/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate3LeastLoaded <- read.csv("output/1w_24-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_replicate10LeastLoaded <- read.csv("output/1w_24-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_schedule.csv", header=T,strip.white=TRUE);
schedule_fullrep <- read.csv("output/1w_24-05-2019/qarnotNodeSchedFullReplicate/out_schedule.csv", header=T,strip.white=TRUE);

# out_pybatsim.csv
schedule_plus_standard <- read.csv("output/1w_24-05-2019/qarnotNodeSched/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_location_based <- read.csv("output/1w_24-05-2019/qarnotNodeSchedAndrei/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate3LeastLoaded <- read.csv("output/1w_24-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_replicate10LeastLoaded <- read.csv("output/1w_24-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_pybatsim.csv", header=T,strip.white=TRUE);
schedule_plus_fullrep <- read.csv("output/1w_24-05-2019/qarnotNodeSchedFullReplicate/out_pybatsim.csv", header=T,strip.white=TRUE);

# out_long_jobs_times.csv
jobs_time_standard <- read.csv("output/1w_24-05-2019/qarnotNodeSched/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_location_based <- read.csv("output/1w_24-05-2019/qarnotNodeSchedAndrei/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate3LeastLoaded <- read.csv("output/1w_24-05-2019/qarnotNodeSchedReplicate3LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_replicate10LeastLoaded <- read.csv("output/1w_24-05-2019/qarnotNodeSchedReplicate10LeastLoaded/out_long_jobs_times.csv", header=T,strip.white=TRUE);
jobs_time_fullrep <- read.csv("output/1w_24-05-2019/qarnotNodeSchedFullReplicate/out_long_jobs_times.csv", header=T,strip.white=TRUE);

jobs_time_standard <- jobs_time_standard %>% filter(jobs_time_standard$start_time != -1)
jobs_time_location_based <- jobs_time_location_based %>% filter(jobs_time_location_based$start_time != -1)
jobs_time_replicate3LeastLoaded <- jobs_time_replicate3LeastLoaded %>% filter(jobs_time_replicate3LeastLoaded$start_time != -1)
jobs_time_replicate10LeastLoaded <- jobs_time_replicate10LeastLoaded %>% filter(jobs_time_replicate10LeastLoaded$start_time != -1)
jobs_time_fullrep <- jobs_time_fullrep %>% filter(jobs_time_fullrep$start_time != -1)

# To add a column for the Scheduler name
schedule_standard$Scheduler <- "Standard"
schedule_location_based$Scheduler <- "LocalityBased"
schedule_replicate3LeastLoaded$Scheduler <- "Replicate3"
schedule_replicate10LeastLoaded$Scheduler <- "Replicate10"
schedule_fullrep$Scheduler <- "FullReplicate"

# To compute and save the max_ and the mean_ waiting time
max_waiting_time_standard <- max(jobs_time_standard$waiting_time)
max_waiting_time_location_based <- max(jobs_time_location_based$waiting_time)
max_waiting_time_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$waiting_time)
max_waiting_time_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$waiting_time)
max_waiting_time_fullrep <- max(jobs_time_fullrep$waiting_time)

schedule_standard$max_waiting_time <- max_waiting_time_standard
schedule_location_based$max_waiting_time <- max_waiting_time_location_based
schedule_replicate3LeastLoaded$max_waiting_time <- max_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_waiting_time <- max_waiting_time_replicate10LeastLoaded
schedule_fullrep$max_waiting_time <- max_waiting_time_fullrep

mean_waiting_time_standard <- mean(jobs_time_standard$waiting_time)
mean_waiting_time_location_based <- mean(jobs_time_location_based$waiting_time)
mean_waiting_time_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$waiting_time)
mean_waiting_time_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$waiting_time)
mean_waiting_time_fullrep <- mean(jobs_time_fullrep$waiting_time)

schedule_standard$mean_waiting_time <- mean_waiting_time_standard
schedule_location_based$mean_waiting_time <- mean_waiting_time_location_based
schedule_replicate3LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_waiting_time <- mean_waiting_time_replicate10LeastLoaded
schedule_fullrep$mean_waiting_time <- mean_waiting_time_fullrep


# To compute and save the max_ and the mean_ slowdown
max_slow_down_standard <- max(jobs_time_standard$slow_down)
max_slow_down_location_based <- max(jobs_time_location_based$slow_down)
max_slow_down_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$slow_down)
max_slow_down_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$slow_down)
max_slow_down_fullrep <- max(jobs_time_fullrep$slow_down)

schedule_standard$max_slow_down <- max_slow_down_standard
schedule_location_based$max_slow_down <- max_slow_down_location_based
schedule_replicate3LeastLoaded$max_slow_down <- max_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_slow_down <- max_slow_down_replicate10LeastLoaded
schedule_fullrep$max_slow_down <- max_slow_down_fullrep

mean_slow_down_standard <- mean(jobs_time_standard$slow_down)
mean_slow_down_location_based <- mean(jobs_time_location_based$slow_down)
mean_slow_down_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$slow_down)
mean_slow_down_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$slow_down)
mean_slow_down_fullrep <- mean(jobs_time_fullrep$slow_down)

schedule_standard$mean_slow_down <- mean_slow_down_standard
schedule_location_based$mean_slow_down <- mean_slow_down_location_based
schedule_replicate3LeastLoaded$mean_slow_down <- mean_slow_down_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_slow_down <- mean_slow_down_replicate10LeastLoaded
schedule_fullrep$mean_slow_down <- mean_slow_down_fullrep


# To compute the max and mean of bounded slowdown
max_bsd_standard <- max(jobs_time_standard$bsd)
max_bsd_location_based <- max(jobs_time_location_based$bsd)
max_bsd_replicate3LeastLoaded <- max(jobs_time_replicate3LeastLoaded$bsd)
max_bsd_replicate10LeastLoaded <- max(jobs_time_replicate10LeastLoaded$bsd)
max_bsd_fullrep <- max(jobs_time_fullrep$bsd)

schedule_standard$max_bsd <- max_bsd_standard
schedule_location_based$max_bsd <- max_bsd_location_based
schedule_replicate3LeastLoaded$max_bsd <- max_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$max_bsd <- max_bsd_replicate10LeastLoaded
schedule_fullrep$max_bsd <- max_bsd_fullrep



mean_bsd_standard <- mean(jobs_time_standard$bsd)
mean_bsd_location_based <- mean(jobs_time_location_based$bsd)
mean_bsd_replicate3LeastLoaded <- mean(jobs_time_replicate3LeastLoaded$bsd)
mean_bsd_replicate10LeastLoaded <- mean(jobs_time_replicate10LeastLoaded$bsd)
mean_bsd_fullrep <- mean(jobs_time_fullrep$bsd)

schedule_standard$mean_bsd <- mean_bsd_standard
schedule_location_based$mean_bsd <- mean_bsd_location_based
schedule_replicate3LeastLoaded$mean_bsd <- mean_bsd_replicate3LeastLoaded
schedule_replicate10LeastLoaded$mean_bsd <- mean_bsd_replicate10LeastLoaded
schedule_fullrep$mean_bsd <- mean_bsd_fullrep

# To bind the _schedules with the _schedule_plus
schedule_standard_full <- bind_cols(schedule_standard, schedule_plus_standard)
schedule_location_based_full <- bind_cols(schedule_location_based, schedule_plus_location_based)
schedule_replicate3LeastLoaded_full <- bind_cols(schedule_replicate3LeastLoaded, schedule_plus_replicate3LeastLoaded)
schedule_replicate10LeastLoaded_full <- bind_cols(schedule_replicate10LeastLoaded, schedule_plus_replicate10LeastLoaded)
schedule_fullrep_full <- bind_cols(schedule_fullrep, schedule_plus_fullrep)



df_all_1w_24 <- rbind(schedule_standard_full, schedule_location_based_full, schedule_replicate3LeastLoaded_full, schedule_replicate10LeastLoaded_full, schedule_fullrep_full)

df_all_1w_24$consumed_joules <- df_all_1w_24$consumed_joules / 100000000
#df_all_1w_24$total_data_transfer <- df_all_1w_24$total_data_transfer / 1000000000

df_all_gathered_1w_24 <- gather(df_all_1w_24, 
                          factor_key = TRUE, 
                          key = "metrics", 
                          value = "values",
                          -batsim_version, -Scheduler)

df_all_gathered_1w_24$Workload <- '1w_24'


#str(df_all_1w_03)
df_all_1w_03$Workload <- '1w_03'
df_all_1w_10$Workload <- '1w_10'
df_all_1w_17$Workload <- '1w_17'
df_all_1w_24$Workload <- '1w_24'

df_all_weeks <- rbind(df_all_1w_03, df_all_1w_10, df_all_1w_17, df_all_1w_24)
#df_all_weeks <- rbind(df_all_1w_10, df_all_1w_17, df_all_1w_24)
#print(df_all_weeks$mean_bsd)

#df_all_weeks_data <- c(df_all_weeks$Workload,df_all_weeks$max_bsd)
df_all_weeks_data <- df_all_weeks %>% select(Workload, 
                                             Scheduler, 
                                             nb_transfers_real, 
                                             total_transferred_GB, 
                                             max_waiting_time, 
                                             mean_waiting_time,                 
                                             mean_slow_down, 
                                             max_slow_down,
                                             mean_bsd, 
                                             max_bsd,
                                             nb_preempted_jobs)
#df_all_gathered <- df_all_weeks_data



df_all_gathered <- gather(df_all_weeks_data, 
                          factor_key = TRUE, 
                          key = "metrics", 
                          value = "values",
                          -Scheduler, -Workload)


#------------------------------------------------------------------------------------------ Waiting time

#write.csv(df_plot, file = "metrics.csv")
df_plot <- subset(df_all_gathered, 
                  #metrics == 'max_waiting_time' |
                  metrics == 'mean_waiting_time'
                 )

labels <- c(
            #max_waiting_time = 'Max waiting time (s)' ,
            mean_waiting_time = 'Mean waiting time (s)')

p <- 
    ggplot(df_plot, aes(Workload, values)) + 
    #geom_point(alpha = 1) + geom_line(alpha = 1, linetype="dotted") +
    geom_bar(aes(fill = Scheduler), position = "dodge", stat="identity") +
    scale_fill_viridis_d() +
    facet_wrap(~ metrics, scales = "free_y", ncol = 1, labeller = labeller(metrics = labels)) +
    scale_y_continuous(limits = c(0,NA), expand = expand_scale(mult = .1)) +
    #scale_x_discrete(expand = c(0.30,0.30)) +
    ggtitle("") + #"Comparison metrics for different Schedulers ") +
    #xlab("Workloads") +
    ylab("") +
    #theme_bw() +
    theme_gray() +
    theme(
    	text = element_text(size=18),
        plot.title = element_text(hjust = 0.5),
        legend.position= "right",
        legend.justification = "center",
        legend.direction = "vertical",
        panel.grid.major = element_blank())+
        #panel.grid.minor = element_blank())+
        #axis.text.x=element_blank(),
    ggsave('long_metrics_mean_waitingTime.png')

#write.csv(df_plot, file = "metrics.csv")
df_plot <- subset(df_all_gathered, 
                  metrics == 'max_waiting_time' #|
                  #metrics == 'mean_waiting_time'
                 )

labels <- c(
            max_waiting_time = 'Max waiting time (s)' #,
            #mean_waiting_time = 'Mean waiting time (s)'
            )

p <- 
    ggplot(df_plot, aes(Workload, values)) + 
    #geom_point(alpha = 1) + geom_line(alpha = 1, linetype="dotted") +
    geom_bar(aes(fill = Scheduler), position = "dodge", stat="identity") +
    scale_fill_viridis_d() +
    facet_wrap(~ metrics, scales = "free_y", ncol = 1, labeller = labeller(metrics = labels)) +
    scale_y_continuous(limits = c(0,NA), expand = expand_scale(mult = .1)) +
    #scale_x_discrete(expand = c(0.30,0.30)) +
    ggtitle("") + #"Comparison metrics for different Schedulers ") +
    #xlab("Workloads") +
    ylab("") +
    #theme_bw() +
    theme_gray() +
    theme(
    	text = element_text(size=18),
        plot.title = element_text(hjust = 0.5),
        legend.position= "right",
        legend.justification = "center",
        legend.direction = "vertical",
        panel.grid.major = element_blank())+
        #panel.grid.minor = element_blank())+
        #axis.text.x=element_blank(),
    ggsave('long_metrics_max_waitingTime.png')


#------------------------------------------------------------------------------------------ Waiting time


#write.csv(df_plot, file = "metrics.csv")
df_plot <- subset(df_all_gathered, 
                  #metrics == 'mean_slow_down' |
                 # metrics == 'max_slow_down' |
                  #metrics == 'mean_bsd' |
                  metrics == 'max_bsd' 
                 )

labels <- c(
            
            #mean_slow_down = 'mean slowdown' ,
            #max_slow_down = 'max slowdown' ,
            #mean_bsd = 'Mean bounded slowdown (log10)' ,
            max_bsd = 'Max bounded slowdown (log10)'
            )

p <- 
    ggplot(df_plot, aes(Workload, values)) + 
    #geom_point(alpha = 1) + geom_line(alpha = 1, linetype="dotted") +
    geom_bar(aes(fill = Scheduler), position = "dodge", stat="identity") +
    scale_fill_viridis_d() +
    facet_wrap(~ metrics, scales = "free_y", ncol = 1, labeller = labeller(metrics = labels)) +
    #scale_y_continuous(limits = c(0,NA), expand = expand_scale(mult = .1)) +
    scale_y_log10() +
    ggtitle("") + #"Comparison metrics for different Schedulers ") +
    #xlab("Workloads") +
    ylab("") +
    theme_gray() +
    theme(
    	text = element_text(size=18),
        plot.title = element_text(hjust = 0.5),
        legend.position= "right",
        legend.justification = "center",
        legend.direction = "vertical",
        panel.grid.major = element_blank())+
        #panel.grid.minor = element_blank())+
        #axis.text.x=element_blank(),
    ggsave('long_metrics_max_slowdown.png')


#write.csv(df_plot, file = "metrics.csv")
df_plot <- subset(df_all_gathered, 
                  #metrics == 'mean_slow_down' |
                 # metrics == 'max_slow_down' |
                  metrics == 'mean_bsd' #|
                  #metrics == 'max_bsd' 
                 )

labels <- c(
            
            #mean_slow_down = 'mean slowdown' ,
            #max_slow_down = 'max slowdown' ,
            mean_bsd = 'Mean bounded slowdown (log10)' #,
            #max_bsd = 'Max bounded slowdown (log10)'
            )

p <- 
    ggplot(df_plot, aes(Workload, values)) + 
    #geom_point(alpha = 1) + geom_line(alpha = 1, linetype="dotted") +
    geom_bar(aes(fill = Scheduler), position = "dodge", stat="identity") +
    scale_fill_viridis_d() +
    facet_wrap(~ metrics, scales = "free_y", ncol = 1, labeller = labeller(metrics = labels)) +
    #scale_y_continuous(limits = c(0,NA), expand = expand_scale(mult = .1)) +
    scale_y_log10() +
    ggtitle("") + #"Comparison metrics for different Schedulers ") +
    #xlab("Workloads") +
    ylab("") +
    theme_gray() +
    theme(
    	text = element_text(size=18),
        plot.title = element_text(hjust = 0.5),
        legend.position= "right",
        legend.justification = "center",
        legend.direction = "vertical",
        panel.grid.major = element_blank())+
        #panel.grid.minor = element_blank())+
        #axis.text.x=element_blank(),
    ggsave('long_metrics_mean_slowdown.png')



#------------------------------------------------------------------------------------------ Waiting time



#write.csv(df_plot, file = "metrics.csv")
df_plot <- subset(df_all_gathered, 
                  #metrics == 'total_transferred_GB' |
                  metrics == 'nb_transfers_real' #|
                 )

labels <- c(
            #total_transferred_GB = 'Total data transfered (GB)',
            nb_transfers_real = 'Number of data transfers')


p <- 
    ggplot(df_plot, aes(Workload, values)) + 
    #geom_point(alpha = 1) + geom_line(alpha = 1, linetype="dotted") +
    geom_bar(aes(fill = Scheduler), position = "dodge", stat="identity") +
    scale_fill_viridis_d() + 
    facet_wrap(~ metrics, scales = "free_y", ncol = 1, labeller = labeller(metrics = labels)) +
    #scale_y_continuous(limits = c(0,NA), expand = c(0.5,0)) +
    scale_y_continuous(limits = c(0,NA), expand = expand_scale(mult = .1)) +
    #scale_x_discrete(expand = c(0.30,0.30)) +
    ggtitle("") + #"Comparison metrics for different Schedulers ") +
    #xlab("Workloads") +
    ylab("") +
    #theme_bw() +
    theme_gray() +
    theme(
    	text = element_text(size=18),
        plot.title = element_text(hjust = 0.5),
        legend.position= "right",
        legend.justification = "center",
        legend.direction = "vertical",
        panel.grid.major = element_blank())+
        #panel.grid.minor = element_blank())+
        #axis.text.x=element_blank(),
    ggsave('long_metrics_total_transferred_data.png')

#write.csv(df_plot, file = "metrics.csv")
df_plot <- subset(df_all_gathered, 
                  metrics == 'total_transferred_GB' #|
                  #metrics == 'nb_transfers_real' #|
                 )

labels <- c(
            total_transferred_GB = 'Total data transfered (GB)'#,
            #nb_transfers_real = 'Number of data transfers')
            )

p <- 
    ggplot(df_plot, aes(Workload, values)) + 
    #geom_point(alpha = 1) + geom_line(alpha = 1, linetype="dotted") +
    geom_bar(aes(fill = Scheduler), position = "dodge", stat="identity") +
    scale_fill_viridis_d() + 
    facet_wrap(~ metrics, scales = "free_y", ncol = 1, labeller = labeller(metrics = labels)) +
    #scale_y_continuous(limits = c(0,NA), expand = c(0.5,0)) +
    scale_y_continuous(limits = c(0,NA), expand = expand_scale(mult = .1)) +
    #scale_x_discrete(expand = c(0.30,0.30)) +
    ggtitle("") + #"Comparison metrics for different Schedulers ") +
    #xlab("Workloads") +
    ylab("") +
    #theme_bw() +
    theme_gray() +
    theme(
    	text = element_text(size=18),
        plot.title = element_text(hjust = 0.5),
        legend.position= "right",
        legend.justification = "center",
        legend.direction = "vertical",
        panel.grid.major = element_blank())+
        #panel.grid.minor = element_blank())+
        #axis.text.x=element_blank(),
    ggsave('long_metrics_nb_transfers_data.png')