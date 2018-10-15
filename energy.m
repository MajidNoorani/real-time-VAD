function [E] = energy(frames)
E = zeros(size(frames,1),1);
for frame= 1 : size(frames,1)
    for i = 1:size(frames,2)
        E(frame)=frames(frame,i)^2+E(frame);
    end
end