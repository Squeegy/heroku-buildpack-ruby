require 'spec_helper'

describe "Rake Runner" do
  it "runs rake tasks that exist" do
    Hatchet::App.new('asset_precompile_pass').in_directory do
      rake = LanguagePack::Helpers::RakeRunner.new.load_rake_tasks!
      task = rake.task("assets:precompile")
      task.invoke

      expect(task.status).to   eq(:pass)
      expect(task.output).to   match("success!")
      expect(task.time).not_to be_nil
    end
  end

  it "detects when rake tasks fail" do
    Hatchet::App.new('asset_precompile_fail').in_directory do
      rake = LanguagePack::Helpers::RakeRunner.new.load_rake_tasks!
      task = rake.task("assets:precompile")
      task.invoke

      expect(task.status).to   eq(:fail)
      expect(task.output).to   match("assets:precompile fails")
      expect(task.time).not_to be_nil
    end
  end

  it "can show errors from bad Rakefiles" do
    Hatchet::App.new('bad_rakefile').in_directory do
      rake = LanguagePack::Helpers::RakeRunner.new.load_rake_tasks!
      task = rake.task("assets:precompile")
      expect(rake.rakefile_can_load?).to be_false
      expect(task.task_defined?).to      be_false
    end
  end

  it "detects if task is missing" do
    Hatchet::App.new('asset_precompile_not_found').in_directory do
      task = LanguagePack::Helpers::RakeRunner.new.task("assets:precompile")
      expect(task.task_defined?).to be_false
    end
  end
end
