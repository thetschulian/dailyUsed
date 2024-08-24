### Script that checks the Axis.com Camera Website for Firmwares


import requests
from bs4 import BeautifulSoup
from datetime import datetime

# URL of the Axis OS release notes
url = "https://help.axis.com/en-us/axis-os-release-notes"

# Version pattern to search for (e.g., "9.80." or "10.12" or "11." )
version_pattern = "9.80"

def normalize_date(date_text):
    # Replace any non-standard dash with a standard hyphen
    normalized_text = date_text.replace('–', '-').strip()
    # Remove any text that appears after the actual date (e.g., "(to be rolled out within 3 weeks of release date)")
    normalized_text = normalized_text.split()[0]  # Keep only the first part (the date)
    try:
        # Attempt to parse the normalized date
        return datetime.strptime(normalized_text, "%Y-%m-%d")
    except ValueError:
        return None

def extract_firmware_versions():
    # Send a GET request to the webpage
    print(f"Sending GET request to URL: {url}")
    response = requests.get(url)
    
    # Check if the request was successful
    print(f"Response status code: {response.status_code}")
    
    if response.status_code == 200:
        # Parse the HTML content using BeautifulSoup
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Search for all sections that might contain firmware details
        firmware_data = []

        # Locate all h3 headers that contain firmware version
        firmware_sections = soup.find_all('h3')

        for section in firmware_sections:
            version = section.get_text(strip=True)
            if version_pattern in version:
                # Find the parent container of the section to search within it
                parent_container = section.find_parent('section') or section.find_parent('div')
                
                if parent_container:
                    # Extract the release date within this parent container
                    release_date_element = parent_container.find('p', string=lambda text: text and "Release date:" in text)
                    if release_date_element:
                        release_date_text = release_date_element.get_text(strip=True).replace("Release date:", "").strip()
                        release_date = normalize_date(release_date_text)
                    else:
                        release_date = None

                    firmware_data.append((version, release_date))
        
        # Display all matching firmware versions with their release dates
        print(f"\nFirmware versions matching '{version_pattern}x' found:")
        for version, release_date in firmware_data:
            if release_date:
                date_str = release_date.strftime("%Y-%m-%d")
                if release_date > datetime.now():
                    print(f"{version} - \033[91m{date_str} (Future Release)\033[0m")
                else:
                    print(f"{version} - {date_str}")
            else:
                print(f"{version} - Release date not found")
        
        # Identify and display the newest firmware version
        if firmware_data:
            newest_firmware, newest_date = max(firmware_data, key=lambda v: [int(part) for part in v[0].split()[-1].split('.') if part.isdigit()])
            if newest_date:
                date_str = newest_date.strftime("%Y-%m-%d")
                if newest_date > datetime.now():
                    print(f"\nThe newest firmware version is: {newest_firmware} - \033[91m{date_str} (Future Release)\033[0m")
                else:
                    print(f"\nThe newest firmware version is: {newest_firmware} - {date_str}")
            else:
                print(f"\nThe newest firmware version is: {newest_firmware} - Release date not found")
        else:
            print(f"No firmware versions matching '{version_pattern}x' found.")
    else:
        print(f"Failed to retrieve the page. Status code: {response.status_code}")

if __name__ == "__main__":
    extract_firmware_versions()
