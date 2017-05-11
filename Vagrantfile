# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative './vagrant/shared.rb'

Vagrant.configure("2") do |config|
  create_vm(
    config, name: "origin", id: 1, cpus: 1, memory: 2048,
    extra_disks: 3, extra_disks_size: 40
  )
  create_vm(
    config, name: "origin", id: 2, cpus: 1, memory: 2048,
    extra_disks: 3, extra_disks_size: 40
  )
end
