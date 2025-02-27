#PSYC 259 Homework 1 - Data Import
#For full credit, provide answers for at least 6/8 questions

#List names of students collaborating with (no more than 2): 

#GENERAL INFO 
#data_A contains 12 files of data. 
#Each file (6192_3.txt) notes the participant (6192) and block number (3)
#The header contains metadata about the session
#The remaining rows contain 4 columns, one for each of 20 trials:
#trial_number, speed_actual, speed_response, correct
#Speed actual was whether the figure on the screen was actually moving faster/slower
#Speed response was what the participant report
#Correct is whether their response matched the actual speed

### QUESTION 1 ------ 

# Load the readr package

# ANSWER

library(tidyverse)
library(readr)


### QUESTION 2 ----- 

# Read in the data for 6191_1.txt and store it to a variable called ds1
# Ignore the header information, and just import the 20 trials
# Be sure to look at the format of the file to determine what read_* function to use
# And what arguments might be needed

# ds1 should look like this:

# # A tibble: 20 × 4
#  trial_num    speed_actual speed_response correct
#   <dbl>       <chr>        <chr>          <lgl>  
#     1          fas          slower         FALSE  
#     2          fas          faster         TRUE   
#     3          fas          faster         TRUE   
#     4          fas          slower         FALSE  
#     5          fas          faster         TRUE   
#     6          slo          slower         TRUE
# etc..

# A list of column names are provided to use:

#colnames  <-  c("trial_num","speed_actual","speed_response","correct")

# ANSWER

fname = "data_A/6191_1.txt"
colnames  <-  c("trial_num","speed_actual","speed_response","correct")
ds1 <- read_tsv(file = fname, col_names = colnames, skip = 7)
print(ds1)


### QUESTION 3 ----- 

# For some reason, the trial numbers for this experiment should start at 100
# Create a new column in ds1 that takes trial_num and adds 100
# Then write the new data to a CSV file in the "data_cleaned" folder

# ANSWER

ds1 <- ds1 %>%
  mutate(new_trial_num = trial_num + 100)

write.csv(ds1, "data_cleaned/updated_ds1.csv", row.names = FALSE)


### QUESTION 4 ----- 

# Use list.files() to get a list of the full file names of everything in "data_A"
# Store it to a variable

# ANSWER

file_list <- list.files("data_A", full.names = TRUE)
print(file_list)


### QUESTION 5 ----- 

# Read all of the files in data_A into a single tibble called ds

# ANSWER

col_spec <- cols(
  trial_num = col_character(),
  speed_actual = col_character(),
  speed_response = col_character(),
  correct = col_logical()
)

ds_list <- lapply(file_list, function(file) {
  read_tsv(file, col_names = colnames, skip = 7, col_types = col_spec)
})

ds <- bind_rows(ds_list)
print(ds)


### QUESTION 6 -----

# Try creating the "add 100" to the trial number variable again
# There's an error! Take a look at 6191_5.txt to see why.
# Use the col_types argument to force trial number to be an integer "i"
# You might need to check ?read_tsv to see what options to use for the columns
# trial_num should be integer, speed_actual and speed_response should be character, and correct should be logical
# After fixing it, create the column to add 100 to the trial numbers 
# (It should work now, but you'll see a warning because of the erroneous data point)

# ANSWER

convert_integer <- function(x) {
  ifelse(x == "ten", 10, as.integer(x))
}

ds <- ds %>%
  mutate(trial_num = convert_integer(trial_num))

ds_100 <- ds %>%
  mutate(new_trial_num = trial_num + 100)
print(ds_100)


### QUESTION 7 -----

# Now that the column type problem is fixed, take a look at ds
# We're missing some important information (which participant/block each set of trials comes from)
# Read the help file for read_tsv to use the "id" argument to capture that information in the file
# Re-import the data so that filename becomes a column

# ANSWER

ds_list <- lapply(file_list, function(file) {
  read_tsv(file, col_names = colnames, skip = 7, col_types = col_spec, id = "filename")
})

ds <- bind_rows(ds_list)
print(ds)


### QUESTION 8 -----

# Your PI emailed you an Excel file with the list of participant info 
# Install the readxl package, load it, and use it to read in the .xlsx data in data_B
# There are two sheets of data -- import each one into a new tibble

# ANSWER

install.packages("readxl")
library(readxl)

excel_file <- "data_B/participant_info.xlsx"

colnames_sheet2 <- c("id", "date")

sheet1 <- read_excel(excel_file, sheet = 1)
sheet2 <- read_excel(excel_file, sheet = 2, col_names = colnames_sheet2)

print(sheet1)
print(sheet2)

