clear all;

zmq_request('init');

requester = zmq_request('add_requester', 'tcp://localhost:6000');
requester = int32(requester);

disp('Start Pupil recording');
zmq_request('send_request', requester, 'start');

reply = zmq_request('receive_reply', requester, 3000)
if isnan(reply)
	zmq_request('close');
	error('Impossible to communicate with the Pupil server.');
end

pause(1);

disp('Stop Pupil recording');
zmq_request('send_request', requester, 'stop');

reply = zmq_request('receive_reply', requester, 3000)
if isnan(reply)
	zmq_request('close');
	error('Impossible to communicate with the Pupil server.');
end

zmq_request('close');
