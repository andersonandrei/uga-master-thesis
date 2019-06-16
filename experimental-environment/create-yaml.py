#!/usr/bin/python3

import argparse
import jinja2
import os

def init_jinja():
    """
    Initialize the jinja2 environment with templates' location.
    """
    template_dir = os.path.dirname(os.path.abspath(__file__))
    # template_dir = os.path.join(template_dir, 'templates')
    environment = jinja2.Environment(
        loader=jinja2.FileSystemLoader(template_dir),
        trim_blocks=True,
        lstrip_blocks=True
    )
    return environment


def parse_cli():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-i', '--input',
        required=True,
        help='input directory of sample-data'
    )
    parser.add_argument(
        '-s', '--sched',
        required=True,
        help='Scheduler name'
    )
    parser.add_argument(
        '--update',
        default=600,
        help='Update_period of the scheduler')
    args = parser.parse_args()
    args.update = str(args.update)
    return args


def main():
    args = parse_cli()

    sample_data_path = "/home/andrei/simulator-prototype/sample-data"
    experiments_path = "/home/andrei/experiments-mascots-2019"
    sched_path = "/home/andrei/pybatsim/schedulers/greco"

    in_path = sample_data_path + "/" + args.input
    out_path = experiments_path + "/output/" + str(args.input) + "_" + str(args.sched) + "_" + str(args.update)
    scheduler = sched_path + "/" + args.sched + ".py"
    yaml_file = experiments_path + "/yaml/" + args.input + "_" + args.sched + "_" + args.update + ".yaml"
    socket = "ipc://" + args.input + "_" + args.sched + "_" + args.update

    j2_env = init_jinja()
    simgrid_template = j2_env.get_template('robin.yaml.template')
    out_stream = simgrid_template.stream(
        in_path=in_path,
        out_path=out_path,
        scheduler=scheduler,
        update_period=args.update,
        socket=socket)
    out_stream.dump(yaml_file)


if __name__ == '__main__':
    main()
