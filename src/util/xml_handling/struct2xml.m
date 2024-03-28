function varargout = struct2xml( s, varargin )

xmlname = fieldnames(s);
xmlname=xmlname{1};
%substitute special characters
xmlname_sc = matlab.lang.makeValidName(xmlname);

if(nargin == 2)
    file = varargin{1};
    
    if (isempty(file))
        error('Filename can not be empty');
    end
    
    if (isempty(strfind(file,'.xml')))
        file = [file '.xml'];
    end
end

%create xml structure
docNode = com.mathworks.xml.XMLUtils.createDocument(xmlname_sc);
%process the rootnode
docRootNode = docNode.getDocumentElement;
%append childs
parseStruct(s.(xmlname),docNode,docRootNode,[inputname(1) '.' xmlname '.']);

if(nargout == 0)
    %save xml file
    xmlwrite(file,docNode);
else
    varargout{1} = xmlwrite(docNode);
end
end

% ----- Subfunction parseStruct -----
function [] = parseStruct(s,docNode,curNode,pName)

fnames = fieldnames(s);
for i = 1:length(fnames)
    curfield=fnames{i};
    curfield_sc = matlab.lang.makeValidName(curfield);
    
    if (strcmp(curfield,'Attributes'))
        %Attribute data
        if (isstruct(s.(curfield)))
            attr_names = fieldnames(s.Attributes);
            for a = 1:length(attr_names)
                cur_attr = attr_names{a};
                cur_attr_sc = matlab.lang.makeValidName(cur_attr);
                
                [cur_str,succes] = val2str(s.Attributes.(cur_attr));
                if (succes)
                    curNode.setAttribute(cur_attr_sc,cur_str);
                else
                    disp(['Warning. The text in ' pName curfield '.' cur_attr ' could not be processed.']);
                end
            end
        else
            disp(['Warning. The attributes in ' pName curfield ' could not be processed.']);
            disp(['The correct syntax is: ' pName curfield '.attribute_name = ''Some text''.']);
        end
    elseif (strcmp(curfield,'Text'))
        if ~all(isspace(s.Text))
            curNode.appendChild(docNode.createTextNode(s.Text));
        end
    elseif (strcmp(curfield,'Comment'))
        if ~all(isspace(s.Comment))
            curNode.appendChild(docNode.createComment(s.Comment));
        end
    else
        %Sub-element
        if (isstruct(s.(curfield)))
            %single element
            curElement = docNode.createElement(curfield_sc);
            curNode.appendChild(curElement);
            parseStruct(s.(curfield),docNode,curElement,[pName curfield '.'])
        elseif (iscell(s.(curfield)))
            %multiple elements
            for c = 1:length(s.(curfield))
                curElement = docNode.createElement(curfield_sc);
                curNode.appendChild(curElement);
                if (isstruct(s.(curfield){c}))
                    parseStruct(s.(curfield){c},docNode,curElement,[pName curfield '{' num2str(c) '}.'])
                else
                    disp(['Warning. The cell ' pName curfield '{' num2str(c) '} could not be processed, since it contains no structure.']);
                end
            end
            
        end
    end
end
end


%----- Subfunction val2str -----
function [str,succes] = val2str(val)

succes = true;
str = [];

if (isempty(val))
    return; %bugfix from H. Gsenger
elseif (ischar(val))
    %do nothing
elseif (isnumeric(val))
    val = num2str(val);
else
    succes = false;
end
%         str=val;

if (ischar(val))
    %add line breaks to all lines except the last (for multiline strings)
    lines = size(val,1);
    val = [val char(sprintf('\n')*[ones(lines-1,1);0])];
    
    %transpose is required since indexing (i.e., val(nonspace) or val(:)) produces a 1-D vector.
    %This should be row based (line based) and not column based.
    valt = val';
    
    remove_multiple_white_spaces = true;
    if (remove_multiple_white_spaces)
        %remove multiple white spaces using isspace, suggestion of T. Lohuis
        whitespace = isspace(val);
        nonspace = (whitespace + [zeros(lines,1) whitespace(:,1:end-1)])~=2;
        nonspace(:,end) = [ones(lines-1,1);0]; %make sure line breaks stay intact
        str = valt(nonspace');
    else
        str = valt(:);
    end
end
end
