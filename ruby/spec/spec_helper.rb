# encoding: utf-8

FIXTURE_DIR = File.join(dir = File.expand_path(File.dirname(__FILE__)), "fixtures")

def fixture_path(rel_path)
  File.join(FIXTURE_DIR, rel_path)
end