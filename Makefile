# Makefile For Cluster

single-up:
	vagrant --config=single up

single-destroy:
	vagrant --config=single destroy

cluster-up:
	vagrant --config=cluster up

cluster-destroy:
	vagrant --config=cluster destroy

clean:
	rm -rf .vagrant output scripts/setup_node.retry
