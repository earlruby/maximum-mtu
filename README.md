# Determine maximum MTU

(Originally published on 2020-02-14 on my blog)[https://earlruby.org/2020/02/determine-maximum-mtu/]

I first started paying attention to network MTU settings when I was building petabyte-scale object storage systems. Tuning the network that backs your storage requires maximizing the size of the data packets and verifying that packets aren’t being fragmented. Currently I’m working on performance tuning the processing of image data using racks of GPU servers and verifying the network MTU came up again. I dug up a script I’d used before and thought I’d share it in case other people run into the same problem.

You can set the host network interface’s MTU setting to 9000 on all of the hosts in your network to enable jumbo frames, but how can you verify that the settings are working? If you’ve set up servers in a cloud environment using multiple availability zones or multiple regions, how can you verify that there isn’t a switch somewhere in the middle of your connection that doesn’t support MTU 9000 and fragments your packets?

Use the (max-mtu.sh)[https://github.com/earlruby/maximum-mtu/blob/main/max-mtu.sh] shell script.

- `-s` $size sets the size of the packet being sent.
- `-M` do prohibits fragmentation, so ping fails if the packet fragments.
- `-c1` sends 1 packet only.
- `size-4+28` = subtract the last 4 bytes added (that caused the fragmentation), add 28 bytes for the IP and ICMP headers.

If minimizing packet fragmentation is important to you, set MTU to 9000 on all hosts and then run this test between every pair of hosts in the network. If you get an unexpectedly low value, troubleshoot your switch and host settings and fix the issue.

Assuming that all of your hosts and switches are configured at their maximum MTU values, then the minimum value returned from the script is the actual maximum MTU you can support without fragmentation. Use the minimum value returned as your new host interface MTU setting.

If you’re operating in a cloud environment you may need to repeat this exercise from time to time as switches are changed and upgraded at your cloud provider.

Hope you find this useful.

