/*
 * Copyright (c) EMC Inc, Greenplum division, 2013. All Rights Reserved. 
 *
 * Author: A.Grishchenko
 * Email:  Aleksey.Grishchenko@emc.com
 * Date:   08 Apr 2013
 * Description: This module contains a list of functions for in-database
 * manipulations with arrays
 *
 * Examples of usage:
 *   select array_operations.array_merge     (array[1,2,3], array[2,3,4])::int[]; --returns [1,2,3,4]::int[]
 */

/*
    Functions to merge two arrays into one. For instance: [1,2,3] and [2,4] is [1,2,3,4]
 */
create or replace function array_operations.array_merge_py (a varchar, b varchar) returns varchar as $BODY$
return '|'.join(sorted(set(a.split('|')) | set(b.split('|'))));
$BODY$
language plpythonu
immutable;

create or replace function array_operations.array_merge (a anyarray, b anyarray) returns varchar[] as $BODY$
begin
if a is null then
	return b::varchar[];
end if;
if b is null then
	return a::varchar[];
end if;
return string_to_array(array_operations.array_merge_py(
		array_to_string(a, '|'),
		array_to_string(b, '|')), '|');
end;
$BODY$
language plpgsql
immutable;