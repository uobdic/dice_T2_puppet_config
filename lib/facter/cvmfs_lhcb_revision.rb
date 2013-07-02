# Fact: cvmfs_lhcb_revision
#
# Purpose: Report the CVMFS revision for LHCb
#
Facter.add(:cvmfs_lhcb_revision) do
  setcode do
    begin
      Facter::Util::Resolution.exec("/usr/bin/cvmfs-talk -i lhcb revision")
    rescue Exception
      Facter.debug('cvmfs not found')
    end
  end
end
