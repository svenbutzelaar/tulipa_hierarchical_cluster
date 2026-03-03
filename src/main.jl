using DuckDB: DBInterface
using DataFrames
using DuckDB
import TulipaIO as TIO
import TulipaEnergyModel as TEM
using TulipaClustering: TulipaClustering
include("cluster_partitions.jl")


database_name = "obz.db"


# 1. Set up the connection and read the data
connection = DBInterface.connect(DuckDB.DB, database_name)

cluster_partitions!(connection, 3000, true)



