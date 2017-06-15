class Facter::Util::Infiniband
  # REF: http://cateee.net/lkddb/web-lkddb/INFINIBAND.html
  LSPCI_IB_REGEX = /\s(1077|15b3|1678|1867|18b8|1fc1):/

  # lspci is a delegating helper method intended to make it easier to stub the
  # system call without affecting other calls to Facter::Core::Execution.exec
  def self.lspci(command = "lspci -n 2>/dev/null")
    #TODO: Deprecated in facter-2.0
    Facter::Util::Resolution.exec command
    #TODO: Not supported in facter < 2.0
    #Facter::Core::Execution.exec command
  end

  # Returns the number of InfiniBand interfaces found
  # in lspci output
  #
  # @return [Integer]
  #
  # @api private
  def self.count_ib_devices
    if Facter::Util::Resolution.which('lspci')
      output = self.lspci
      matches = output.scan(LSPCI_IB_REGEX)
      matches.flatten.reject {|s| s.nil?}.length
    end
  end

  # Reads the contents of path in sysfs
  #
  # @return [String]
  #
  # @api private
  def self.read_sysfs(path)
    output = File.read(path)
    return nil if output.nil?
    output.strip
  end

  # Returns firmware version of an InfiniBand port
  #
  # @return [String]
  #
  # @api private
  def self.get_port_fw_version(port)
    sysfs_base_path = File.join("/sys/class/infiniband/", port)
    fw_version = nil

    case port
    when /^mlx/
      sysfs_fw_file = File.join(sysfs_base_path, "fw_ver")
    when /^qib/
      sysfs_fw_file = File.join(sysfs_base_path, "version")
    else
      return nil
    end

    fw_version = self.read_sysfs(sysfs_fw_file)
    fw_version
  end

  # Returns board_id of an InfiniBand port
  #
  # @return [String]
  #
  # @api private
  def self.get_port_board_id(port)
    sysfs_path = File.join("/sys/class/infiniband", port, "board_id")
    board_id = self.read_sysfs(sysfs_path)
    board_id
  end

  # Returns Array of InfiniBand ports
  #
  # @return [Array]
  #
  # @api private
  def self.get_ports
    ports = Dir.glob('/sys/class/infiniband/*').collect { |d| File.basename(d) }
    ports
  end

  # Returns rate of InifniBand port
  #
  # @return [String]
  #
  # @api private
  def self.get_port_rate(port)
    port_sysfs_path = Dir.glob(File.join('/sys/class/infiniband', port, 'ports', '*')).first
    return nil if port_sysfs_path.nil?

    rate_sysfs_path = File.join(port_sysfs_path, 'rate')
    rate = self.read_sysfs(rate_sysfs_path)
    rate
  end
end
