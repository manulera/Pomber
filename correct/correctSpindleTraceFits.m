% We copy the original one just in case
clear all
close all
!cp pomber_save.mat pomber_save_safecopy.mat
% We load the data
load('pomber_save.mat')
%%

for i = 1:numel(out.cells)
    
    f_sp = out.cells{i}.features{2};
    t = 1:numel(f_sp.len);
    figure
    hold on
    plot(t,f_sp.len)
    plot(t,spindle_trace_fun(t,f_sp.length_fit))
    vline(f_sp.length_fit(1))
    vline(f_sp.length_fit(2))
    while true
        [x,y]=getpts();
        if numel(x)==0
            break
        end
        
        sugg=[25,1,1,3,f_sp.len(1)];
        f_sp.length_fit=fitSpindleTraceFunFixedTimes(t,f_sp.len,x(1),x(2),sugg );
        plot(t,spindle_trace_fun(t,f_sp.length_fit))
    end
end

%%
save('pomber_save.mat','out')