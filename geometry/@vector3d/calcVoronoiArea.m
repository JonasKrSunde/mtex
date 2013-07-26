function [area,centroids] = calcVoronoiArea(v,varargin)
% compute the area of the Voronoi decomposition
%
% Input
%  v - @vector3d
%
% Output
%  area - area of the corresponding Voronoi cells
%  centroids - centroid of the voronoi cell
%
% Options
% incomplete -

v = reshape(v,[],1);

% in case of antipodal symmetry - add antipodal points
antipodal = v.antipodal;
if antipodal
  v = [v;-v];
  v.antipodal = false;
end

[V,C] = calcVoronoi(v);

nd = ~cellfun('isempty',C);
v = v.subsref(nd);

last = cumsum(cellfun('prodofsize',C(nd)));

left = [C{nd}];
shift = 2:last(end)+1;             % that is the shift
shift(last) = [0;last(1:end-1)]+1; % and the last gets the first
right = left(shift);

center = cumsum([1 diff(shift)>1]);

va = v.subsref(center);
vb = V.subsref(left);
vc = V.subsref(right);    % next vertex around

% calculate the area for each triangle around generator (va)
A = real(sphericalTriangleArea(va,vb,vc));

if nargout>1
  [x,y,z]= double(A.*(va+vb+vc));
  x = full(sparse(center,1,x,numel(S2G),1));
  y = full(sparse(center,1,y,numel(S2G),1));
  z = full(sparse(center,1,z,numel(S2G),1));
  centroids = vector3d(x,y,z);
end

% accumulate areas of spherical triangles around generator
A = full(sparse(center,1,A,length(v),1));

area = zeros(size(nd));
area(nd) = A(1:nnz(nd));

if antipodal
  area = sum(reshape(area,[],2),2);
end

