#!/usr/bin/env python3
import os
import xml.etree.ElementTree as ET

# Define the path to scan
include_path = './firmware/build/include/'

# Define the output XML file
output_xml_file = 'eclipse_include_paths.xml'

# Template for the XML content
xml_template = '''<?xml version="1.0" encoding="UTF-8"?>
<cdtprojectproperties>
<section name="org.eclipse.cdt.internal.ui.wizards.settingswizards.IncludePaths">
<language name="s">

</language>
<language name="c,S">
<includepath workspace_path="true">/${ProjName}/src/microros</includepath>
<!-- Insert your entries below this line -->
</language>
<language name="ld">

</language>
<language name="Object File">

</language>
</section>
<section name="org.eclipse.cdt.internal.ui.wizards.settingswizards.Macros">
<language name="s">

</language>
<language name="c,S">

</language>
<language name="ld">

</language>
<language name="Object File">

</language>
</section>
</cdtprojectproperties>
'''

# Parse the XML template
root = ET.ElementTree(ET.fromstring(xml_template)).getroot()

# Find the <language name="c,S"> element
language_c_s = root.find(".//language[@name='c,S']")

# List all directories in the include_path
directories = [d for d in os.listdir(include_path) if os.path.isdir(os.path.join(include_path, d))]

# Insert each directory as an includepath element
for directory in directories:
    includepath = ET.SubElement(language_c_s, 'includepath')
    includepath.set('workspace_path', 'true')
    includepath.text = f'/${{ProjName}}/src/microros/{directory}'

# Write the modified XML to the output file
tree = ET.ElementTree(root)
tree.write(output_xml_file, encoding='UTF-8', xml_declaration=True)

print(f"XML file '{output_xml_file}' has been created successfully.")
