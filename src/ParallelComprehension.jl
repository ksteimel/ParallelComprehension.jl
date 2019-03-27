module ParallelComprehension
export @par_comp
macro par_comp(comp)
    if comp.head == :comprehension
        content = comp.args[1]
        op = :+
        op = content.args[1].args[1]
        operands = content.args[1].args[2:end]
        temp_var = content.args[2].args[1]
        source = content.args[2].args[2]
        source_ind = 0
        # find the value in our list of operands
        # that matches our source array
        for operand_i = 1:length(operands)
            if operands[operand_i] == temp_var
                source_ind = operand_i
            end
        end
        if source_ind == 0
            throw("Parsing error during @par_comp macro expansion")
        elseif length(operands) == 1
             quote
                # init array
                first_res = $(esc(op))($(esc(source))[1])
                res_array = Array{typeof(first_res)}(undef, length($(esc(source))))
                for index = 1:length($(esc(source)))
                    res_array[index] = $(esc(op))($(esc(source))[index])
                end
                res_array
            end     
        elseif source_ind == 1 # our matching variable is the first place in the function call
            quote
                # init array
                first_res = $(esc(op))($(esc(source))[1], $(esc(operands[2:end]...)))
                res_array = Array{typeof(first_res)}(undef, length($(esc(source))))
                for index = 1:length($(esc(source)))
                    res_array[index] = $(esc(op))($(esc(source))[index], $(esc(operands[2:end]...)))
                end
                res_array
            end
        elseif source_ind == length(operands) # our matching variable is the last place in the function call
            quote
                # init array
                first_res =  $(esc(op))($(esc(operands[1:end-1]...)), $(esc(source))[1])
                res_array = Array{typeof(first_res)}(undef, length($(esc(source))))
                for index = 1:length($(esc(source)))
                    res_array[index] = $(esc(op))($(esc(operands[1:end-1]...)), $(esc(source))[index])
                end
                res_array
            end
      
        else # our matching variable is in the middle of the function call
            quote
                # init array
                first_res = $(esc(op))($(esc(operands[1:source_ind-1]...)), 
                                        $(esc(source))[1], 
                                        $(esc(operands[source_ind+1:end]...)))
                res_array = Array{typeof(first_res)}(undef, length($(esc(source))))
                for index = 1:length($(esc(source)))
                    res_array[index] = $(esc(op))($(esc(operands[1:source_ind-1]...)), 
                                        $(esc(source))[index], 
                                        $(esc(operands[source_ind+1:end]...)))
                end
                res_array
            end
        end
    end
end
end # module
