SetupEnvironment <- function(requiredPackages, workingDirectory = NULL) {
    if (is.null(workingDirectory)) workingDirectory = getwd()
    options(max.print = 1000)
    GetPackages(requiredPackages)
    RequirePackages(requiredPackages)
    SetWorkingDirectory(workingDirectory)
}

GetPackages <- function(PackageNames, repo = 'http://r.meteo.uni.wroc.pl/') {
    new.packages <- PackageNames[!(c(PackageNames) %in% installed.packages()[, "Package"])]
    if (length(new.packages)) install.packages(new.packages, repos = repo)
    }

RequirePackages <- function(PackageNames) {
    lapply(PackageNames, require, character.only = TRUE)
}

SetWorkingDirectory <- function(path) {
    path = gsub("([\\])", "/", path)
    if (path != getwd()) {
        setwd(path)
    }
}

ToCamelCase <- function(x) {
    lower <- tolower(x)
    capit <- function(x) paste0(toupper(substring(lower, 1, 1)), substring(lower, 2, nchar(lower)))
    sapply(strsplit(lower, "\\."), function(lower) paste(capit(lower), collapse = ""))
}