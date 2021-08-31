import os

def walk():
  path = r"."
  for root, dirs, files in os.walk(path):
    for name in files:
      if (len(name) >= 143):
        full_pathname = os.path.join(root, name)
        print('{} {}'.format(len(name), full_pathname))

if __name__ == "__main__":
  walk()
