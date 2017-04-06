function data = pupil_parse_data(data_str)
	% PUPIL_PARSE_DATA Parses the received data from cosy-pupil-server.
	%
	% data = PUPIL_PARSE_DATA(data_str)
	%
	% 'data_str' must be the reply of the 'receive_data' request to the
	% cosy-pupil-server. 'data_str' is a single string with a key:value pair on
	% each line.
	%
	% The return value is a struct array with the keys as the struct fields.
	% For example data(1).pupil_diameter accesses the first pupil_diameter.
	%
	% In 'data_str', the timestamp key must mark the beginning of a new sample.
	%
	% 2016, 2017 - Sébastien Wilmet

	line_feed = 10; % '\n'
	lines = strsplit(data_str, line_feed);

	data = [];

	for line_num = 1:length(lines)
		line = lines{line_num};
		fields = strsplit(line, ':');

		if length(fields) == 2
			name = fields{1};
			value = fields{2};

			if strcmp(name, 'timestamp')
				data(end + 1).timestamp = str2double(value);
			elseif strcmp(name, 'pupil_diameter')
				data(end).pupil_diameter = str2double(value);
			elseif strcmp(name, 'gaze_norm_pos_x')
				data(end).gaze_norm_pos_x = str2double(value);
			elseif strcmp(name, 'gaze_norm_pos_y')
				data(end).gaze_norm_pos_y = str2double(value);
			elseif strcmp(name, 'confidence')
				data(end).confidence = str2double(value);
			end
		end
	end

    % Note that a future version of Matlab has already a strsplit() function.
    function chunks = strsplit(str, delim)
        chunks = {};
        indices = strfind(str, delim);

        a = 1;
        for i = 1:length(indices)
            delim_pos = indices(i);
            b = delim_pos - 1;
            chunks{end+1} = get_chunk(str, a, b);
            a = delim_pos + 1;
        end

        % get last chunk
        b = length(str);
        chunks{end+1} = get_chunk(str, a, b);

        function chunk = get_chunk(str, a, b)
            if a <= b
                chunk = str(a:b);
            else
                chunk = '';
            end
        end
    end
end
