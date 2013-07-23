# Fact: cvmfs_atlas_revision
#
# Purpose: Report the CVMFS revision for ATLAS
#
Facter.add(:SL_release) do
  setcode do
    begin
      Facter::Util::Resolution.exec("lsb_release -d | cut -c 14-")
    rescue Exception
      Facter.debug('lsb_release not found')
    end
  end
end
