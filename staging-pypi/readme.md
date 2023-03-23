# Staging Code Artifact

aws code artifact repo for testing publication of wheels.

goods
 - don't have a separate set of principals to manage like testpypi
   for each maintainer doing releases.
 - packaging issues don't require burning a version.

downs
 - requires using aws auth, with automated releases, this is less of
   a concern.


