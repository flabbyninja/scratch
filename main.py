import zipfile
import re
import random
import datetime

DESIRED_COUNTRIES = ['gb', 'us', 'se']
ENTRIES_PER_COUNTRY = 3

INPUT_ZIP_NAME = 'wireguard_windows_all.zip'
OUTPUT_ZIP_PREFIX = 'output'
CONFIG_REGEX = 'mullvad-[a-z]{2}[0-9]{1,3}.conf$'

def create_filtered_zip(input_zip_file, filtered_file_list, output_zip_file):
  with zipfile.ZipFile(output_zip_file, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as newzip:
    for filename in filtered_file_list:
      file_bytes = input_zip_file.read(filename)
      newzip.writestr(filename, file_bytes)

def create_country_dict(filelist):
  p = re.compile(CONFIG_REGEX)
  country_dict = {}

  for file in filelist:
    if p.match(file):
      country = file[8:10]
      if country in country_dict:
        country_dict[country].append(file)
      else:
        country_dict[country] = [file]
    else:
      print("Ignoring file that doesn't match pattern: ", file)

  return country_dict

def get_random_unique_from_list(data_list, num):
  random_set = set()
  list_len = len(data_list)
  if len(data_list) <= num:
    return data_list
  else:
    while len(random_set) < num:
      random_set.add(data_list[random.randrange(0, list_len - 1)])
    return list(random_set)

def select_random_entries(dict, filterlist, num):
  full_list = []
  for key in filterlist:
    if key in dict:
      full_list += get_random_unique_from_list(dict[key], num)
    else:
      print('Selected key', key, 'does not exist in source config tree')
  return full_list

def main():
  print('Reading input from source file', INPUT_ZIP_NAME)
  with zipfile.ZipFile(INPUT_ZIP_NAME, 'r') as input_zip_file:
    filelist = input_zip_file.namelist()

    # Map contents of source zip to countries based on regex filename
    country_dict = create_country_dict(filelist)

    # Select random entries from each country up to limit provided per country
    print('Filtering output to max of', ENTRIES_PER_COUNTRY, 'entries from keys', DESIRED_COUNTRIES)
    filtered_file_list = select_random_entries(country_dict, DESIRED_COUNTRIES, ENTRIES_PER_COUNTRY)

    # Pull selected config from source, and write into new, generated, timestamped zip
    output_zip_file = datetime.datetime.now().strftime(OUTPUT_ZIP_PREFIX + '_%y%m%d_%H%M%S.zip')
    print('Writing filtered contents to', output_zip_file, 'with config from ', filtered_file_list)
    create_filtered_zip(input_zip_file, filtered_file_list, output_zip_file)
    print('Output file successully created')

if __name__ == '__main__':
  main()