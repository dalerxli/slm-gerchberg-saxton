% trap_obj(trap size, axis, x, y,) 

% impoint methods (for later)
%{
        addNewPositionCallback     le                         
        addlistener                lt                         
        createMask                 ne                         
        delete                     notify                     
        eq                         removeNewPositionCallback  
        findprop                   resume                     
        ge                         setColor                   
        getColor                   setConstrainedPosition     
        getPosition                setPosition                
        getPositionConstraintFcn   setPositionConstraintFcn   
        gt                         setString                  
        impoint                    wait                       
        isvalid                    
%}

classdef trap_obj < impoint 
% object for a single optical trap   
    properties
        trap_sz
        prevPos
    end
    
    methods
        function obj = trap_obj(sz, varargin) % varargin = axis, x, y
            obj = obj@impoint(varargin{:}); % call impoint constructor

            obj.trap_sz = sz; 
            obj.prevPos = obj.getPosition;

            % Make new callback for drawing trap positions 
            addNewPositionCallback(obj, @(pos) drawPoint(pos));

            % boundary constraint function
            bdn = makeConstrainToRectFcn('impoint',...
                get(gca,'XLim')+obj.trap_sz*[2 -2],...
                get(gca,'YLim')+obj.trap_sz*[2 -2]);

            % Enforce boundary constraint
            setPositionConstraintFcn(obj,bdn);
   
            function drawPoint(pos)
                global glb;
                
                SQSZ = glb.sz;
                W = 200; H = 200;  % <- set constant for testing
                
                prevX = round(obj.prevPos(2)-SQSZ/2):round(obj.prevPos(2)+SQSZ/2);
                prevY = round(obj.prevPos(1)-SQSZ/2):round(obj.prevPos(1)+SQSZ/2);
                glb.TARGET(prevX,prevY) = 0;
                
                currX = round(pos(2)-SQSZ/2):round(pos(2)+SQSZ/2);
                currY = round(pos(1)-SQSZ/2):round(pos(1)+SQSZ/2);
                glb.TARGET(currX, currY) = 1;
                obj.prevPos = obj.getPosition;
                
                GS_alg_fast_gpu();
            end
            
        end
        
    end
    
end
 

    
