# Fact: has_enabled_epel_repo
#
# Purpose: Report if the EPEL repo is enabled
#
Facter.add(:has_enabled_epel_repo) do
  setcode do
    begin
      any_enabled = Facter::Util::Resolution.exec("less /etc/yum.repos.d/epel*.repo | grep enabled=1 | wc -l")
      case any_enabled
      when 0
        "no"
      else
        "yes"
      end
    rescue Exception
      Facter.debug('epel repository not found')
    end
  end
end
