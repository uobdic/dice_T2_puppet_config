# Fact: cvmfs_atlas_revision
#
# Purpose: Report the CVMFS revision for ATLAS
#
Facter.add(:cvmfs_atlas_revision) do
  setcode do
    begin
      Facter::Util::Resolution.exec("/usr/bin/cvmfs-talk -i atlas revision")
    rescue Exception
      Facter.debug('cvmfs not found')
    end
  end
end
