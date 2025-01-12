# Use the official Golang image as a base
# Stage 1: Build the Go application
FROM golang:1.23.1-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the Go source code into the container
COPY note-todo-app /app/note-todo-app

# Copy the go.mod file to the container to handle dependencies
COPY note-todo-app/go.mod /app/note-todo-app/

# Run go mod tidy to download dependencies (if any)
#RUN cd /app/note-todo-app && go mod tidy

# Navigate to the source directory and build the Go application
WORKDIR /app/note-todo-app
RUN go build -v -o note-todo-app .

# Stage 2: Create the smaller final image with only the binary
FROM alpine:latest

# Install any required dependencies for the app (e.g., if you need to run the app with libc)
RUN apk --no-cache add ca-certificates


# Set the working directory inside the container
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/note-todo-app/note-todo-app /root/

# Expose the port that the application listens on
EXPOSE 8080

# Command to run the application
CMD ["./note-todo-app"]
