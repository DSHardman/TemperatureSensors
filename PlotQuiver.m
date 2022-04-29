% Uses target/error variables created at end of NN_Training.m

n = 100;
quiver(target(1:n,1),target(1:n,2),errors(1:n,1),errors(1:n,2), 'off');