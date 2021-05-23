import zipfile
import re

def create_filtered_zip(input_zip_file, filtered_file_list, output_zip_file):
  with zipfile.ZipFile(output_zip_file, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as newzip:
    for filename in filtered_file_list:
      file_bytes = input_zip_file.read(filename)
      newzip.writestr(filename, file_bytes)

def get_countries(filelist):
  p = re.compile('mullvad-[a-z][a-z][0-9][0-9].conf$')
  countries = []
  for file in filelist:
    countries.append(file[8:10])
  return set(countries)

def filter_zip_file_contents(filelist):
  countries = get_countries(filelist)
  print('Countries: ', countries)
  return filelist[0:1]

def main():
  input_zip_name = 'wireguard_windows_all.zip'
  output_zip_file = 'output.zip'
        
  with zipfile.ZipFile(input_zip_name, 'r') as input_zip_file:
    filelist = input_zip_file.namelist()
    filtered_file_list = filter_zip_file_contents(filelist)
    create_filtered_zip(input_zip_file, filtered_file_list, output_zip_file)

if __name__ == '__main__':
  print('Starting main...')
  main()
  print('Main complete')