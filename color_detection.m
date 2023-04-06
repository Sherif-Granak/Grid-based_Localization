
function [index] = color_detection(cam)
rgb=snapshot(cam);

r=rgb(:,:,1);
g=rgb(:,:,2);
b=rgb(:,:,3);
r_avg=mean(r,"all");
g_avg=mean(g,"all");
b_avg=mean(b,"all");


colors=["Red","Blue","Black"];
%1  blue 2 red 3 black
disp([r_avg,g_avg,b_avg])

threshold=150;


imshow(rgb);
if abs(r_avg-g_avg)<10 && abs(g_avg-b_avg)<10 && abs(r_avg-b_avg)<10 

    color='Black';
    index=3;

elseif r_avg>g_avg &&  r_avg >b_avg 
    color="Red";
    index=2;

elseif b_avg>g_avg &&  b_avg >r_avg
    color="Blue";
    index=1;

else
    index=3;




% disp([r_avg/val g_avg/val b_avg/val])
% color=colors(index)
%index=0;

end




