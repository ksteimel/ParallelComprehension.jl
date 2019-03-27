using Test
using Random
using Distributions
using SparseArrays
using ParallelComprehension
function some_calculation(a::Number)
    return a + (a ^ 3)/5
end
function longer_function_def(a, b, c, d)
    return sum(a, b, c, d)
end
@testset "basic_functionality" begin
    @testset "floats" begin
        float_arr = rand(10000)
        @test [i * 32 for i in float_arr] == @par_comp [i * 32 for i in float_arr]
        @test [some_calculation(i) for i in float_arr] == @par_comp [some_calculation(i) for i in float_arr]
        @test [longer_function_def(2,1,9,i) for i in float_arr] == 
               @par_comp [longer_function_def(2,1,9,i) for i in float_arr]

        @test [longer_function_def(2,1,i, 6) for i in float_arr] == 
               @par_comp [longer_function_def(2,1,i, 6) for i in float_arr]

        @test [longer_function_def(2,i,1,2) for i in float_arr] == 
               @par_comp [longer_function_def(2,i,1,2) for i in float_arr]
    end
    @testset "strings" begin
        string_array = repeat(["gabba gabba"], 1000)
        @test [ i * " hey hey" for i in string_array ] == @par_comp [i * " hey hey" for i in string_array]
    end
end
