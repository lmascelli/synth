$project = Split-Path -Path (Get-Location) -Leaf

function build {
  New-Item -Type Directory -Path build -ErrorAction Ignore
    Push-Location build
    cmake -G"Ninja" ..
    cmake --build .
    Pop-Location
}

function run {
  Push-Location build
    $command = './' + $project
    Invoke-Expression $command
    Pop-Location
}

switch ($args[0]) {
  "build" {
    build
  }

  "run" {
    build
      run $args[1]
  }

  "init" {
    $init_folder = "new"
      if ($args.Length -ge 2) {
        $init_folder = $args[1]
      }
    New-Item -Type Directory -Path $init_folder
      Copy-Item -Path ./cmake -Recurse -Destination $init_folder
      Copy-Item -Path ./src -Recurse -Destination $init_folder
      Copy-Item -Path ./build -Recurse -Destination $init_folder
      Copy-Item -Path ./CMakeLists.txt -Destination $init_folder
      Copy-Item -Path ./project.ps1 -Destination $init_folder
      Copy-Item -Path ./.gitignore -Destination $init_folder
  }

  default {
    run
  }
}
