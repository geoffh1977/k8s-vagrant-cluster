# Makefile For Cluster

single-up:
	vagrant --config=single up

single-halt:
	vagrant --config=single halt

single-destroy:
	vagrant --config=single destroy

cluster-up:
	vagrant --config=cluster up

cluster-halt:
	vagrant --config=cluster halt

cluster-destroy:
	vagrant --config=cluster destroy

clean:
	rm -rf .vagrant output scripts/setup_node.retry
