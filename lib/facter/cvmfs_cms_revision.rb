# Fact: cvmfs_cms_revision
#
# Purpose: Report the CVMFS revision for CMS
#
Facter.add(:cvmfs_cms_revision) do
  setcode do
    begin
      Facter::Util::Resolution.exec("/usr/bin/cvmfs-talk -i cms revision")
    rescue Exception
      Facter.debug('cvmfs not found')
    end
  end
end
