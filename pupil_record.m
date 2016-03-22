clear all;

zmq_request('init');

requester = zmq_request('add_requester', 'tcp://localhost:6000');
requester = int32(requester);

disp('Start Pupil recording');
tic;
zmq_request('send_request', requester, 'start');

reply = zmq_request('receive_reply', requester, 3000);
if isnan(reply)
	zmq_request('close');
	error('Impossible to communicate with the Pupil server.');
end

if (~strcmp(reply, 'ack'))
	zmq_request('close');
	error('Request not acked');
end

pause(1);

disp('Stop Pupil recording');
zmq_request('send_request', requester, 'stop');

reply = zmq_request('receive_reply', requester, 3000);
if isnan(reply)
	zmq_request('close');
	error('Impossible to communicate with the Pupil server.');
end

elapsed_time_pupil = str2double(reply);
elapsed_time_matlab = toc;
assert(elapsed_time_pupil <= elapsed_time_matlab);
total_latency_ms = (elapsed_time_matlab - elapsed_time_pupil) * 1000;
disp(['Latency between Matlab and Pupil: ', num2str(total_latency_ms), ' ms.']);
if (total_latency_ms > 100)
	warning('The latency between Matlab and Pupil is too high.');
end

disp('Receive data...');
zmq_request('send_request', requester, 'receive_data');

data_str = zmq_request('receive_reply', requester, 30000)
if isnan(data_str)
	zmq_request('close');
	error('Timeout, impossible to communicate with the Pupil server.');
end

zmq_request('close');

data = pupil_parse_data(data_str);
pupil_check_timestamps(data);
