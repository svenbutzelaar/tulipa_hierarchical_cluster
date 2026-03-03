## initialize project

pkg add

TulipaClustering
DuckDB
DataFrames
TulipaIO 
TulipaEnergyModel
DataStructures


## run clustering

You can use `src/main.jl` to perform hierarchical time-series clustering.  
By default, it operates on `obz.db`, which is created from the data in:

`src/data_before_hierarchical_clustering/`

After running `julia src/main.jl`:

- The database (`obz.db`) is updated with the new clustered partitions.
- The modified input files can be exported to:

` src/data_after_hierarchical_clustering/`

by running:

`julia src/to_csv.jl`


## how it works
`src/main.jl` calls the `cluster_partitions!` function in `src/cluster_partitions.jl` which in turn calls `hierarchical_time_clustering_ward` in `src/cluster_ward.jl`

### cluster_partitions.jl

This file integrates the clustering algorithm with the DuckDB database.

1. Time-series data is read from `profiles_rep_periods`.
2. Clustering is applied:
   - Per profile, or
   - Per location (joint clustering of multiple profiles).
3. The resulting partitions are written back to:
   - `assets_rep_periods_partitions`
   - `flows_rep_periods_partitions`

This ensures that the clustered representative periods are consistently reflected in the Tulipa input tables.

### cluster_ward.jl

This file implements hierarchical agglomerative clustering using Ward’s linkage criterion.

- Each timestep initially forms its own cluster.
- Only adjacent (time-contiguous) clusters can be merged.
- The merge that results in the smallest increase in within-cluster variance is selected.
- A min-heap is used to efficiently determine the next best merge.
- The algorithm stops when the requested number of clusters is reached.

The output consists of contiguous time partitions represented by their cluster sizes.
