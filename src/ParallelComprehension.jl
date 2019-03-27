module ParallelComprehension
export @par_comp
macro par_comp(comp)
    if comp.head == :comprehension
        content = comp.args[1]
        op = :+
        op = content.args[1].args[1]
        operand1 = content.args[1].args[2]
        operand2 = content.args[1].args[3]
        temp_var = content.args[2].args[1]
        source = content.args[2].args[2]
        if temp_var != operand1
            temp_operand = operand1
            operand1 = operand2
            operand2 = temp_operand
        end
        quote
            # init array
            first_res = $(esc(op))($(esc(source))[1], $(esc(operand2)))
            res_array = Array{typeof(first_res)}(undef, length($(esc(source))))
            for index = 1:length($(esc(source)))
                res_array[index] = $(esc(op))($(esc(operand2)), $(esc(source))[index])
            end
            res_array
        end
    end
end
end # module
