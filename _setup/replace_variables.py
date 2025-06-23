import yaml
import os
import uuid
import sys
from jinja2 import Template

# Load configuration from config.yaml
def load_config(config_file):
    with open(config_file, 'r') as file:
        config = yaml.safe_load(file)
    return config

# Replace variables in the given file content using Jinja2 templating
def replace_variables_in_file_content(file_path, variables):
    with open(file_path, 'r') as file:
        content = file.read()

    # Use Jinja2 template rendering to replace placeholders
    template = Template(content)
    rendered_content = template.render(variables)

    # Overwrite the file with the rendered content
    with open(file_path, 'w') as file:
        file.write(rendered_content)

# Replace variables in file or folder names
def replace_variables_in_name(name, variables):
    template = Template(name)
    return template.render(variables)

# Create README.md from template
def create_readme_from_template(template_path, output_path, variables):
    """
    Create a README.md file from the template using the provided variables.
    
    Args:
        template_path (str): Path to the README.md.template file
        output_path (str): Path where the generated README.md should be saved
        variables (dict): Dictionary containing variables to replace in the template
    """
    if not os.path.exists(template_path):
        print(f"Warning: README template file not found at {template_path}")
        return
        
    with open(template_path, 'r') as file:
        template_content = file.read()
    
    # Use Jinja2 template rendering to replace placeholders
    template = Template(template_content)
    rendered_content = template.render(variables)
    
    # Write the rendered content to the output file
    with open(output_path, 'w') as file:
        file.write(rendered_content)
    
    print(f"Created README.md at {output_path}")

# Recursively find and replace placeholders in .m and .json files and their names
def replace_in_files_and_folders(root_dir, variables):
    for dirpath, dirnames, filenames in os.walk(root_dir, topdown=False):
        # Replace placeholders in filenames
        for filename in filenames:
            if filename.endswith('.m') or filename.endswith('.json'):
                old_path = os.path.join(dirpath, filename)
                new_filename = replace_variables_in_name(filename, variables)
                new_path = os.path.join(dirpath, new_filename)
                os.rename(old_path, new_path)
                replace_variables_in_file_content(new_path, variables)

        # Replace placeholders in directory names
        for dirname in dirnames:
            old_dirpath = os.path.join(dirpath, dirname)
            new_dirname = replace_variables_in_name(dirname, variables)
            new_dirpath = os.path.join(dirpath, new_dirname)
            os.rename(old_dirpath, new_dirpath)

if __name__ == "__main__":
    # Load the configuration from the YAML file
    config_file = 'config.yaml'
    config = load_config(config_file)
    
    # Get repository information from GitHub environment variables
    github_repository = os.environ.get('GITHUB_REPOSITORY', 'OWNER/REPO')
    repo_owner, repo_name = github_repository.split('/') if '/' in github_repository else ('OWNER', 'REPO')
    
    # Define the placeholders and corresponding values from the config
    variables = {
        'namespace_name': config['matlab_toolbox']['namespace_name'],
        'uuid': str(uuid.uuid4()),  # Dynamically generate a UUID
        'toolbox_name': config['matlab_toolbox']['toolbox_name'],
        'author_name': config['matlab_toolbox']['author_name'],
        'author_email': config['matlab_toolbox']['author_email'],
        'author_company': config['matlab_toolbox']['author_company'],
        'toolbox_summary': config['matlab_toolbox']['toolbox_summary'],
        'toolbox_description': config['matlab_toolbox']['toolbox_description'].replace('\n', ' ').strip(),
        # Repository information
        'repo_owner': repo_owner,
        'repo_name': repo_name,
        # Placeholders for values to be filled in later
        'fex_url': 'https://www.mathworks.com/matlabcentral/fileexchange/YOUR_FEX_ID',
        'codecov_token': 'YOUR_CODECOV_TOKEN'
    }
    
    # Set the root directory for your project (assuming current directory)
    root_dir = '.'

    # Replace variables in all .m and .json files in the project
    replace_in_files_and_folders(root_dir, variables)
    
    # Create README.md from template
    create_readme_from_template('README.md.template', 'README.md', variables)
    
    # Delete setup.yml workflow and README.md.template after they've been used
    files_to_delete = [
        '.github/workflows/setup.yml',
        'README.md.template'
    ]
    
    for file_path in files_to_delete:
        if os.path.exists(file_path):
            os.remove(file_path)
            print(f"Deleted {file_path}")
        else:
            print(f"Warning: {file_path} not found, skipping deletion.")
