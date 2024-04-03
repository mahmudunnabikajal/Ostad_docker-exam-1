# Go Server

A simple go server.

### Instructions to run locally

1. Configure [GO](https://go.dev/doc/install) in your system.
2. Open terminal in project directory.
3. Download the dependencies using this command:
    ```bash
    go mod download
    ```
4. Set environment variable to the system for building the application:
    * `CGO_ENABLED=0`
    * `GOOS=linux`
5. Build the application binary:
    ```bash
    go build .
    ```
5. Set environment variable for running:
    * `PORT=<your_desired_port>`
5. Run the built binary:
    ```bash
   ./docker-gs-ping
    ```
    or 
    ```bash
   go run .
    ```

### Check if the server is running
1. Go to `http://localhost:<given_port>` and check if you see "`Hello, from Ostad! <3`".
2. Go to `http://localhost:<given_port>/health` and check if you see "`{"Status": "OK"}`".
