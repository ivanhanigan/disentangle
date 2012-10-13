
fixGeom <- function(schema, table){
cat(
paste("
 INSERT INTO geometry_columns(f_table_catalog, f_table_schema, f_table_name, f_geometry_column, coord_dimension, srid, \\\"type\\\")
 SELECT '', '",schema,"', '",table,"', 'the_geom', ST_CoordDim(the_geom), ST_SRID(the_geom), GeometryType(the_geom)
 FROM ",schema,".",table," LIMIT 1;
",sep="")
)
}
