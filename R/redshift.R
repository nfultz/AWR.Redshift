
#' Redshift driver class.
#'
#' @keywords internal
#' @export
#' @import RJDBC
#' @import methods
#' @importClassesFrom RJDBC JDBCDriver
setClass("RedshiftDriver", contains = "JDBCDriver")

#' Redshift DBI wrapper
#'
#' @export
Redshift <- function() {
  new("RedshiftDriver")
}

#' Constructor of RedshiftDriver
#' 
#' @name RedshiftDriver
#' @rdname RedshiftDriver-class
setMethod(initialize, "RedshiftDriver",
   function(.Object, ...)
{
    # passed to parent builder, than unboxed, yuck
    # should ping RJDBC maintainers, and have them implement initialize methods instead
    jdbc <- JDBC(driverClass="com.amazon.redshift.jdbc42.Driver",
                 identifier.quote="'")

    .Object@jdrv = jdbc@jdrv
    .Object@identifier.quote = jdbc@identifier.quote
    .Object
})

#' Redshift connection class.
#'
#' Class which represents the Redshift connections.
#'
#' @export
#' @importClassesFrom RJDBC JDBCConnection
#' @keywords internal
setClass("RedshiftConnection",
  contains = "JDBCConnection",
  slots = list(
    host = "character",
    dbname = "character",
    user = "character"
  )
)

#' Authentication credentials are for now passed in as user and password.
#'
#' @param drv An object created by \code{Redshift()}
#' @param host the host
#' @param dbname S3 bucket where results will be saved to
#' @param user Redshift schema to use
#' @param password pw
#' @param ... Other options
#' @rdname Redshift
#' @seealso \href{http://docs.aws.amazon.com/redshift/latest/mgmt/configure-jdbc-options.html}{Redshift Manual} for more connections options.
#' @export
#' @examples
#' \dontrun{
#' require(DBI)
#' con <- conn <- dbConnect(Redshift(), host=config$host, dbname=config$dbname, user=config$user, password=config$password)
#' dbListTables(con)
#' dbGetQuery(con, "Select 1 as bob")
#' }
setMethod("dbConnect", "RedshiftDriver",
          function(drv, host, dbname, user, password, ...) {

  con <- callNextMethod(drv, url=sprintf('jdbc:redshift://%s:5439/%s?user=%s&password=%s&ssl=true&sslfactory=com.amazon.redshift.ssl.NonValidatingFactory', 
                                         host, dbname, user, password), ...)
#                   aws_credentials_provider_class="com.amazonaws.Redshift.jdbc.shaded.com.amazonaws.auth.DefaultAWSCredentialsProviderChain", ...)

  new("RedshiftConnection", jc = con@jc, identifier.quote = drv@identifier.quote, host = host, dbname=dbname, user=user)
})
