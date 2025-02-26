import os
import re
import json
import sys
import numpy as np

# Directory containing log files
log_folders = sys.argv[1:]
tmp_dir = "./tmp"
# Path to the JSON file with all test names
json_path = "test_names.json"
# Regex pattern to match ANSI escape sequences
ansi_escape = re.compile(r'\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])')

# Remove ANSI escape sequences from a log file
def clean_log(file_path, output_path):
    with open(file_path, "r") as infile:
        content = infile.read()
    # Remove ANSI escape sequences
    cleaned_content = ansi_escape.sub('', content)

    with open(output_path, "w") as outfile:
        outfile.write(cleaned_content)

# Remove ANSI escape sequences from all log files
def clean_all_logs(log_folder):
    os.makedirs(tmp_dir, exist_ok=True)
    for file_name in os.listdir(log_folder):
        if file_name.endswith(".log"):
            file_path = os.path.join(log_folder, file_name)
            output_path = os.path.join(tmp_dir, file_name)
            clean_log(file_path, output_path)

# Clean logs file by any additional information
def process_logs(input_files, output_directory, json_file=json_path):
    # Load JSON data
    with open(json_file, 'r') as jf:
        data = json.load(jf)
    
    # Extract the list of names from the JSON file
    names = data.get("names", [])
    if not names:
        print("No names found in the JSON file.")
        return

    # Ensure the output directory exists
    os.makedirs(output_directory, exist_ok=True)

    # Process each input file
    for input_file in input_files:
        with open(input_file, 'r') as infile:
            lines = infile.readlines()

        # Create an output file
        output_file = os.path.join(output_directory, os.path.basename(input_file))
        with open(output_file, 'w') as outfile:
            match_found = False
            buffer = []

            # Process lines to find the match
            for i, line in enumerate(lines):
                if not match_found and any(name in line for name in names):
                    # Check for the "Test" condition on the subsequent line
                    if i + 1 < len(lines) and lines[i + 1].strip().startswith("Test"):
                        match_found = True
                        # Write the buffered line (line before the match), the match, and the next line
                        if buffer:
                            outfile.write(buffer[-1])
                        outfile.write(line)
                        outfile.write(lines[i + 1])
                elif match_found:
                    # Write all lines after the match
                    outfile.write(line)
                else:
                    # Buffer the current line to keep the last line before a match
                    buffer = [line]
            
            if not match_found:
                print(f"No matches found in {input_file}. Output file will be empty.")

    print(f"Processing complete. Processed files saved to {output_directory}.")

# This function parses the name of the benchmark and the number of tests from the log file
# json_file is the json file containing the names of the possible benchmarks
# log_file is the log file of a specific benchmark and it is parsed to extract the name and 
# the number of tests
def parse_name_and_num_tests(json_file, log_file):
    ret_name = None
    ret_number_of_tests = None

    # Parse name
    with open(json_file, "r") as f:
        json_data = json.load(f)

    with open(log_file, "r") as f:
        log_content = f.read()
    
    # The first match is the name of the benchmark
    for name in json_data["names"]:
        if name in log_content:
            ret_name = name
            continue

    # Parse tests numbers
    pattern = r"Test 1 of (\d+)"
    with open(log_file, "r") as f:
        for line in f:
            match = re.search(pattern, line)
            if match: 
                ret_number_of_tests = int(match.group(1))
                continue
    return (ret_name, ret_number_of_tests)

# This function parses a single test from the log file and return a string that needs to be further processed
# log_file is the path to the log file
# test_name is the name of the test to be parsed
# occurrence is the number of the test to be parsed
# if is not possible to parse the test, the function returns an empty string
def parse_single_test(log_file, test_name, occurrence=1):
    test_string = ""

    # Read the file
    with open(log_file, 'r') as file:
        file_content = file.read()

    # Find the string of the occurence test
    start_idx = 0
    for _ in range(occurrence):
        # Find the next "test_name [" starting from the current position
        start_idx = file_content.find(test_name + " [", start_idx)
        # If the occurrence is not found, return ""
        if start_idx == -1: return ""
        # Move start_idx to the position after "test_name ["
        start_idx += len(test_name + " [")
    
    # Find the next occurrence of "test_name" after the first one
    next_start_idx = file_content.find(test_name + " [", start_idx)
    # If no second "test_name" is found, extract everything from the first "test_name" to the end of the file
    # Else, extract the text between the two "test_name" occurrences
    if next_start_idx == -1: test_string = file_content[start_idx:]
    else: test_string = file_content[start_idx:next_start_idx]
    
    return test_string

# This function parses a log file and returns a json string with the test results
def from_log_to_json(input_file, json_file="test_names.json"):
    # Collect the name of the benchmark and the number of tests on it
    name, num_tests = parse_name_and_num_tests(json_file, input_file)

    test_array = []

    # For each test, parse the test and create a dictionary
    for i in range(num_tests):
        test_string = parse_single_test(input_file, name, i+1)

        if test_string == "":
            print(f"Error parsing test: {name} number: {i+1}")
            continue
        
        # Collect test description
        end_description_idx = test_string.find("]")
        test_description = test_string[0:end_description_idx]
        
        # Collect test values
        start_values_index = test_string.find(test_description, end_description_idx)
        values_string = test_string[start_values_index+len(test_description):]
        
        # Before "Average:" is the part of the string that contains the values
        parts = values_string.split("Average:")
        # if "Average:" is not found, the test values are missing
        # else consider the values are in the first part of the string
        if len(parts) < 2: substring = ""
        else: substring = parts[0]



        # Find all numbers
        numbers = re.findall(r'\b\d+\.?\d*\b', substring)
        # Convert found numbers to float or int
        numeric_values = [float(num) if '.' in num else int(num) for num in numbers]

        if len(numeric_values) == 0:
            print(f"Error parsing test: {name} number: {i+1} with description: {test_description}")
            continue

        # Collect measure unit
        measure_unit = ""
        match = re.search(r'Average:\s*\d+\.?\d*\s+([^\n]+)', test_string)
        if match: measure_unit = match.group(1).strip()

        # Create a dictionary for the test
        test_dict = {
            "description": test_description,
            "values": numeric_values,
            "unit": measure_unit,
            "average": np.mean(numeric_values),
            "std_dev": np.std(numeric_values)
        }

        test_array.append(test_dict)

    # if is not possible to parse any test, return an empty string
    if len(test_array) == 0: return ""
    
    # else return the json string with all tests
    full_test = { name : test_array}
    full_test_json = json.dumps(full_test, indent=4)
    return full_test_json


if __name__ == "__main__":
    for log_folder in log_folders:
        # Remove escape sequences from all log files and save them in tmp_dir
        clean_all_logs(log_folder)

        # List of input text files
        input_files_list = []
        for file_name in os.listdir(tmp_dir):
            if file_name.endswith(".log"):
                file_path = os.path.join(tmp_dir, file_name)
                input_files_list.append(file_path)

        # Clean the log files and save them in a new folder
        cleaned_folder = log_folder + "/cleaned"
        os.makedirs(cleaned_folder, exist_ok=True)
        process_logs(input_files_list, cleaned_folder)

        # Remove the temporary folder
        if os.path.exists(tmp_dir):
            for file_name in os.listdir(tmp_dir):
                os.remove(os.path.join(tmp_dir, file_name))
            os.rmdir(tmp_dir)

        # Iterate through each file in the cleaned folder
        json_tests = []
        for file_name in os.listdir(cleaned_folder):
            # Check if the file has a .log extension
            if file_name.endswith('.log'):
                file_path = os.path.join(cleaned_folder, file_name)
                # Parse the log file and append the json to the list
                json_test = from_log_to_json(file_path)
                if json_test != "": json_tests.append(json_test)
        
        # Write the json to a file
        json_output_file = cleaned_folder + "/results.json"
        try:
            with open(json_output_file, 'w') as f:
                json.dump(json_tests, f)
            print(f"JSON saved to {json_output_file}")
        except Exception as e:
            print(f"An error occurred while saving JSON: {e}")