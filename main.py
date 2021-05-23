import zipfile
import re

INPUT_ZIP_NAME = 'wireguard_windows_all.zip'
OUTPUT_ZIP_NAME = 'output.zip'
CONFIG_REGEX = 'mullvad-[a-z]{2}[0-9]{1,3}.conf$'
DESIRED_COUNTRIES = ['gb', 'us', 'se']
ENTRIES_PER_COUNTRY = 3

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

def select_random_entries(dict, filterlist, num):
  full_list = []
  for key in filterlist:
    if key in dict:
      print('Found key ', key)
    else:
      print('Key ', key, ' does not exist in dict')
  for key in dict.keys():
      full_list += dict[key]
  return full_list

def main():
  with zipfile.ZipFile(INPUT_ZIP_NAME, 'r') as input_zip_file:
    filelist = input_zip_file.namelist()
    country_dict = create_country_dict(filelist)
    filtered_file_list = select_random_entries(country_dict, DESIRED_COUNTRIES, ENTRIES_PER_COUNTRY)
    print(filtered_file_list)
    # create_filtered_zip(input_zip_file, filtered_file_list, OUTPUT_ZIP_NAME)

if __name__ == '__main__':
  print('Starting main...')
  main()
  print('Main complete')