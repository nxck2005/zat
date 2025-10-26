# zat
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Zig Version](https://img.shields.io/badge/zig-0.15.1+-orange.svg)

A simple `cat` implementation written in Zig.

## Prerequisites

- Zig compiler version 0.15.1 or later.

## Building

To build the project, clone the repository and run the following command:

```sh
zig build
```

This will create the `zat` executable in the `zig-out/bin/` directory.

## Usage

To display the content of a file, use the following command:

```sh
./zig-out/bin/zat <filename>
```

For example:

```sh
./zig-out/bin/zat README.md
```

### Running with Zig

You can also run the program directly using the build system:

```sh
zig build run -- <filename>
```


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.