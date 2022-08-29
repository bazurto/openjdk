# OpenJDK

## Usage

1. Download the latest version of Bazurto CLI from https://github.com/bazurto/bz
2. Create a `.bz` file in your root of your project with the following content:
    ```hcl
    deps = [
        "github.com/bazurto/openjdk-v17.0.4.1"
    ]
    ```
3. Now you can execute java commands in your project. e.g.:
    ```bash
    bz java ... 
    ```

    or 


    ```bash
    bz bash
    java ...
    ```
