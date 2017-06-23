#' @importFrom utils packageVersion download.file
#' @importFrom rJava .jpackage
.onLoad <- function(libname, pkgname) {

    ## path to the JDBC driver
    file <- sprintf('RedshiftJDBC42-%s.jar', packageVersion(pkgname))
    path <- file.path(system.file('java', package = pkgname), file)

    ## check if the jar is available and install if needed (on first load)
    if (!file.exists(path)) {

        url <- paste0('https://s3.amazonaws.com/redshift-downloads/drivers/', file)

        ## download the jar file from AWS
        try(download.file(url = url, destfile = path, mode = 'wb'),
            silent = TRUE)

    }


    ## add the RJDBC driver and the log4j properties file to classpath
    rJava::.jpackage(pkgname, lib.loc = libname)

}

.onAttach <- function(libname, pkgname) {

    ## let the user know if the automatic JDBC driver installation failed
    path <- system.file('java', package = pkgname)
    if (length(list.files(path, '^RedshiftJDBC42-[0-9.]*jar$')) == 0) {
        packageStartupMessage(
            'The automatic installation of the Redshift JDBC driver seems to have failed.\n',
            'Please check your Internet connection and if the current user can write to ', path, '\n',
            'If still having issues, install the jar file manually from:\n',
            'http://docs.aws.amazon.com/redshift/latest/mgmt/configure-jdbc-connection.html\n')
    }

}
