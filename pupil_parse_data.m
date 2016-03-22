function parsed_data = pupil_parse_data(data)
	line_feed = 10; % '\n'
	lines = strsplit(data, line_feed);

	parsed_data = [];

	for line_num = 1:length(lines)
		line = lines{line_num};
		fields = strsplit(line, ':');

		if length(fields) == 2
			name = fields{1};
			value = fields{2};
			if strcmp(name, 'diameter_px')
				parsed_data(end + 1).diameter_px = str2num(value);
			elseif strcmp(name, 'timestamp')
				parsed_data(end).timestamp = str2num(value);
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
